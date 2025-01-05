//
//  HealthKitManager.swift
//  Steps
//
//  Created by Eric Carroll on 8/5/24.
//

@preconcurrency import HealthKit
import SwiftData
import CoreMotion
import SwiftUI
import WidgetKit

@MainActor
class HealthKitManager: ObservableObject {
    private var healthStore: HKHealthStore
    private let motionActivityManager = CMMotionActivityManager()
    private weak var dataManager: DataManager?

    @Published var stepCount: [String: Int] = [:]
    @Published var activeEnergyBurned: [String: Double] = [:]
    @Published var distanceWalkingRunning: [String: Double] = [:]
    @Published var activeTime: [String: Double] = [:]
    @Published var walkingSpeed: [String: Double] = [:]
    @Published var lastActiveTimestamp: TimeInterval? = nil
    @Published var walkingStepLength: [String: Double] = [:]
    @Published var goalSteps: Int {
        didSet {
            UserDefaults.standard.set(goalSteps, forKey: "goalSteps")
        }
    }
    
    var totalSteps: Int { stepCount.values.reduce(0, +) }
    var totalCalories: Double { activeEnergyBurned.values.reduce(0, +) }
    var totalDistance: Double { distanceWalkingRunning.values.reduce(0, +) }
    var totalMoveTime: Double { activeTime.values.reduce(0, +) }
    var averageWalkingSpeed: Double { calculateAverage(for: walkingSpeed) }
    var averageWalkingStepLength: Double { calculateAverage(for: walkingStepLength) }
    var goalPercentage: Double { goalSteps > 0 ? Double(totalSteps) / Double(goalSteps) : 0 }

    init(goalSteps: Int = 10000, dataManager: DataManager) {
        self.healthStore = HKHealthStore()
        self.goalSteps = UserDefaults.standard.object(forKey: "goalSteps") as? Int ?? 10_000
        self.dataManager = dataManager
        startTrackingMotion()
        
        Task {
            await self.startTrackingMetricsAndMotion(for: Date.now)
        }
    }

    func trackDailyStats(for date: Date) {
        dataManager?.saveDailyStats(
            steps: totalSteps,
            distance: totalDistance,
            calories: totalCalories,
            walkingSpeed: averageWalkingSpeed,
            walkingStepLength: averageWalkingStepLength,
            activeTime: totalMoveTime,
            stepGoal: goalSteps
        )

        if let stats = dataManager?.fetchDailyStats(for: date) {
            print("Active Time: \(stats.activeTime)")
            print("Steps: \(stats.steps)")
        }
    }

    func startTrackingMetricsAndMotion(for date: Date) async {
        // Start tracking metrics
        await startTrackingMetrics(for: date)
        
        // Save and fetch daily stats
        trackDailyStats(for: date)
    }
    
    private func calculateAverage(for metric: [String: Double]) -> Double {
        guard !metric.isEmpty else { return 0 }
        let total = metric.values.reduce(0, +)
        return total / Double(metric.count)
    }
    
    var hourlyStepCounts: [String: Int] {
        var completeStepCounts = [String: Int]()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: Date())

        for hour in 0...currentHour {
            let hourKey = String(format: "%02d", hour) // Format as "00", "01", etc.
            completeStepCounts[hourKey] = stepCount[hourKey] ?? 0 // Default to 0 if missing
        }

        return completeStepCounts
    }
    
    func requestAuthorization() async {
        let typesToRead: Set<HKObjectType> = [
            .quantityType(forIdentifier: .stepCount)!,
            .quantityType(forIdentifier: .distanceWalkingRunning)!,
            .quantityType(forIdentifier: .activeEnergyBurned)!,
            .quantityType(forIdentifier: .walkingSpeed)!,
            .quantityType(forIdentifier: .walkingStepLength)!
        ]

        do {
            try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
        } catch {
            print("Error requesting authorization: \(error.localizedDescription)")
        }
    }
    
    func checkAuthorizationStatus() -> Bool {
        let typesToCheck: [HKQuantityTypeIdentifier] = [
            .stepCount,
            .distanceWalkingRunning,
            .activeEnergyBurned,
            .walkingSpeed,
            .walkingStepLength
        ]
        
        for typeIdentifier in typesToCheck {
            guard let type = HKObjectType.quantityType(forIdentifier: typeIdentifier) else { continue }
            let status = healthStore.authorizationStatus(for: type)
            if status != .sharingAuthorized {
                print("Authorization not granted for \(typeIdentifier.rawValue)")
                return false
            }
        }
        return true
    }
    
    func startTrackingMotion() {
        if CMMotionActivityManager.isActivityAvailable() {
//            motionActivityManager.startActivityUpdates(to: OperationQueue()) { [weak self] activity in
//                guard let self = self, let activity = activity else { return }
//
//                if activity.walking || activity.running {
//                    let currentTimestamp = Date().timeIntervalSince1970
//                    
//                    Task { @MainActor in
//                        // Safely access `lastActiveTimestamp` on the main actor
//                        let lastActiveTimestamp = self.lastActiveTimestamp
//
//                        // Switch back to the background thread for computation
//                        DispatchQueue.global().async {
//                            if let lastActiveTimestamp = lastActiveTimestamp {
//                                let timeElapsed = currentTimestamp - lastActiveTimestamp
//                                if timeElapsed > 0 {
//                                    let hourKey = Date().currentHourKey()
//                                    let dayKey = Date().currentDayKey()
//
//                                    // Update activeTime on the main actor
//                                    Task { @MainActor in
//                                        self.activeTime[hourKey] = ((self.activeTime[hourKey] ?? 0) + timeElapsed) / 60
//                                        self.activeTime[dayKey] = (self.activeTime[dayKey] ?? 0) + timeElapsed
//                                        self.lastActiveTimestamp = currentTimestamp
//                                    }
//                                }
//                            } else {
//                                // If no previous timestamp, set it on the main actor
//                                Task { @MainActor in
//                                    self.lastActiveTimestamp = currentTimestamp
//                                }
//                            }
//                        }
//                    }
//                }
//            }
            motionActivityManager.startActivityUpdates(to: .main) { [weak self] activity in
                guard let self = self, let activity = activity else { return }

                // Check if the user is walking or running
                if activity.walking || activity.running {
                    // Get the current timestamp
                    let currentTimestamp = Date().timeIntervalSince1970

                    // If we were already active, calculate the time spent since the last update
                    if let lastActiveTimestamp = self.lastActiveTimestamp {
                        let timeElapsed = currentTimestamp - lastActiveTimestamp
                        if timeElapsed > 0 {
                            // Get current hour and date
                            let hourKey = self.formatDate(Date(), dateFormat: "HH") // Get the current hour
                            let dayKey = self.formatDate(Date(), dateFormat: "yyyy-MM-dd") // Get the current date

                            // Increment active time by the time difference
                            if let hourKey = hourKey, let dayKey = dayKey {
                                self.activeTime[hourKey] = ((self.activeTime[hourKey] ?? 0) + timeElapsed) / 60
                                self.activeTime[dayKey] = (self.activeTime[dayKey] ?? 0) + timeElapsed
                            }
                        }
                    }

                    // Update the last active timestamp
                    self.lastActiveTimestamp = currentTimestamp
                }
            }
        }
    }
    
    func startTrackingMetrics(for date: Date) async {
        let metrics: [MetricType] = [
            .stepCount,
            .activeEnergyBurned,
            .distanceWalkingRunning,
            .walkingSpeed,
            .walkingStepLength
        ]

        let descriptors = metrics.compactMap { metricType -> HKStatisticsCollectionQueryDescriptor? in
            guard let sampleType = metricType.sampleType else { return nil }
            return createDescriptor(for: sampleType as! HKQuantityType, options: metricType.defaultOptions, date: date)
        }

        await streamAllStatistics(descriptors: descriptors, metrics: metrics)
    }
    
    private func createDescriptor(for quantityType: HKQuantityType, options: HKStatisticsOptions, date: Date) -> HKStatisticsCollectionQueryDescriptor {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date) // Start of the selected day
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? Date()
        let anchorDate = calendar.startOfDay(for: endDate)
        let interval = DateComponents(hour: 1)
        let predicate = HKSamplePredicate<HKQuantitySample>.quantitySample(
            type: quantityType,
            predicate: HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        )
        
        let descriptor = HKStatisticsCollectionQueryDescriptor(
            predicate: predicate,
            options: options,
            anchorDate: anchorDate,
            intervalComponents: interval
        )
        
        return descriptor
    }
    
    private let unitMapping: [HKQuantityTypeIdentifier: HKUnit] = [
        .stepCount: HKUnit.count(),
        .activeEnergyBurned: HKUnit.kilocalorie(),
        .distanceWalkingRunning: HKUnit.mile(),
        .walkingSpeed: HKUnit.mile().unitDivided(by: HKUnit.hour()),
        .walkingStepLength: HKUnit.inch()
    ]

    private func getUnit(for sampleType: HKSampleType) -> HKUnit? {
        let identifier = HKQuantityTypeIdentifier(rawValue: sampleType.identifier)
        return unitMapping[identifier]
    }
    
    @MainActor
    func streamAllStatistics(descriptors: [HKStatisticsCollectionQueryDescriptor], metrics: [MetricType]) async {
        await withTaskGroup(of: Void.self) { group in
            for (descriptor, metricType) in zip(descriptors, metrics) {
                if let sampleType = metricType.sampleType {
                    // Here we pass only the necessary details from descriptor
                    let predicate = descriptor.predicate
                    let options = descriptor.options
                    let anchorDate = descriptor.anchorDate
                    let intervalComponents = descriptor.intervalComponents

                    group.addTask { @Sendable [weak self] in
                        // We create a new descriptor inside the closure to avoid capturing a non-Sendable type
                        let safeDescriptor = HKStatisticsCollectionQueryDescriptor(
                            predicate: predicate,
                            options: options,
                            anchorDate: anchorDate,
                            intervalComponents: intervalComponents
                        )
                        await self?.streamStatistics(descriptor: safeDescriptor, sampleType: sampleType)
                    }
                } else {
                    print("Invalid sample type for metric: \(metricType.rawValue)")
                }
            }
        }
    }

    @MainActor
    private func streamStatistics(descriptor: HKStatisticsCollectionQueryDescriptor, sampleType: HKSampleType) async {
        do {
            for try await update in descriptor.results(for: healthStore) {
                // Process the statistics on the main actor
                for statistic in update.statisticsCollection.statistics() {
                    await processStatistics(statistic: statistic, sampleType: sampleType)
                }

                if let updatedStatistics = update.updatedStatistics {
                    for statistic in updatedStatistics {
                        await processStatistics(statistic: statistic, sampleType: sampleType)
                    }
                }
            }
        } catch {
            print("Error streaming statistics for \(sampleType.identifier): \(error)")
        }
    }

    @MainActor
    private func processStatistics(statistic: HKStatistics, sampleType: HKSampleType) async {
        guard let dateKey = formatDate(statistic.startDate, dateFormat: "HH") else { return }
        guard let unit = getUnit(for: sampleType) else {
            print("Unsupported sample type: \(sampleType.identifier)")
            return
        }

        let value: Double
        if sampleType.identifier == HKQuantityTypeIdentifier.walkingSpeed.rawValue ||
           sampleType.identifier == HKQuantityTypeIdentifier.walkingStepLength.rawValue {
            value = statistic.averageQuantity()?.doubleValue(for: unit) ?? 0
        } else {
            value = statistic.sumQuantity()?.doubleValue(for: unit) ?? 0
        }

        withAnimation {
            updateMetric(for: MetricType(rawValue: sampleType.identifier) ?? .stepCount, value: value, dateKey: dateKey)
        }
    }
    
    private func fetchStatistics(descriptor: HKStatisticsCollectionQueryDescriptor) async -> (MetricType, [HKStatistics]) {
        let metricType = MetricType(rawValue: descriptor.predicate.sampleType.identifier) ?? .stepCount
        var statistics: [HKStatistics] = []

        do {
            for try await update in descriptor.results(for: healthStore) {
                if let updatedStatistics = update.updatedStatistics {
                    statistics.append(contentsOf: updatedStatistics)
                } else {
                    statistics.append(contentsOf: update.statisticsCollection.statistics())
                }
            }
        } catch {
            print("Error streaming statistics for \(metricType): \(error)")
        }

        return (metricType, statistics)
    }
    
    private var metricsDictionary: [String: Any] {
        [
            MetricType.stepCount.rawValue: Binding(
                get: { self.stepCount },
                set: { self.stepCount = $0 }
            ),
            MetricType.activeEnergyBurned.rawValue: Binding(
                get: { self.activeEnergyBurned },
                set: { self.activeEnergyBurned = $0 }
            ),
            MetricType.distanceWalkingRunning.rawValue: Binding(
                get: { self.distanceWalkingRunning },
                set: { self.distanceWalkingRunning = $0 }
            ),
            MetricType.walkingSpeed.rawValue: Binding(
                get: { self.walkingSpeed },
                set: { self.walkingSpeed = $0 }
            ),
            MetricType.walkingStepLength.rawValue: Binding(
                get: { self.walkingStepLength },
                set: { self.walkingStepLength = $0 }
            )
        ]
    }
    
    @MainActor
    private func updateMetric(for type: MetricType, value: Double, dateKey: String?) {
        guard let dateKey = dateKey else {
            print("Invalid dateKey: \(String(describing: dateKey))")
            return
        }

        // Use raw value for dictionary lookup
        if let publishedMetric = metricsDictionary[type.rawValue] as? Binding<[String: Double]> {
            // Debugging: Check the current value for the key

            withAnimation {
                // Update the metric value
                publishedMetric.wrappedValue[dateKey] = value
            }
        } else if let publishedMetric = metricsDictionary[type.rawValue] as? Binding<[String: Int]> {
            withAnimation {
                // Update the metric value
                publishedMetric.wrappedValue[dateKey] = Int(value)
            }
        } else {
            print("Metric type \(type.rawValue) not found in metricsDictionary.")
        }
    }
    
    enum MetricType: String {
        case stepCount = "HKQuantityTypeIdentifierStepCount"
        case activeEnergyBurned = "HKQuantityTypeIdentifierActiveEnergyBurned"
        case distanceWalkingRunning = "HKQuantityTypeIdentifierDistanceWalkingRunning"
        case walkingSpeed = "HKQuantityTypeIdentifierWalkingSpeed"
        case walkingStepLength = "HKQuantityTypeIdentifierWalkingStepLength"

        var sampleType: HKSampleType? {
            switch self {
            case .stepCount:
                return HKQuantityType.quantityType(forIdentifier: .stepCount)
            case .activeEnergyBurned:
                return HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
            case .distanceWalkingRunning:
                return HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
            case .walkingSpeed:
                return HKQuantityType.quantityType(forIdentifier: .walkingSpeed)
            case .walkingStepLength:
                return HKQuantityType.quantityType(forIdentifier: .walkingStepLength)
            }
        }
    }

    private func formatDate(_ date: Date, dateFormat: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat // Set the desired format
        return formatter.string(from: date)
    }
    
    func saveStepsToSharedStorage(goalSteps: Int, totalSteps: Int) {
        if let sharedDefaults = UserDefaults(suiteName: "group.com.UsefulApps.Steps") {
            sharedDefaults.set(goalSteps, forKey: "goalSteps")
            sharedDefaults.set(totalSteps, forKey: "totalSteps")
            sharedDefaults.synchronize()
        } else {
            print("Error: Could not access shared UserDefaults")
        }
        
        print(goalSteps, " ", totalSteps)
        WidgetCenter.shared.reloadAllTimelines()
    }
}

private extension HealthKitManager.MetricType {
    var defaultOptions: HKStatisticsOptions {
        switch self {
        case .stepCount, .activeEnergyBurned, .distanceWalkingRunning:
            return .cumulativeSum
        case .walkingSpeed, .walkingStepLength:
            return .discreteAverage
        }
    }
}
