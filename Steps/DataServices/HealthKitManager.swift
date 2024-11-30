//
//  HealthKitManager.swift
//  Steps
//
//  Created by Eric Carroll on 8/5/24.
//

import HealthKit
import SwiftData
import CoreMotion

@MainActor
class HealthKitManager: ObservableObject {
    private var healthStore: HKHealthStore
    private var query: HKStatisticsCollectionQuery?

    let motionActivityManager = CMMotionActivityManager()
    
    @Published var stepCount: [String: Int] = [:]
    @Published var activeEnergyBurned: [String: Double] = [:]
    @Published var distanceWalked: [String: Double] = [:]
    @Published var activeTime: [String: Double] = [:]
    @Published var walkingSpeed: [String: Double] = [:]
    @Published var walkingStepLength: [String: Double] = [:]
    @Published var goalSteps: Int = 10000 // Default step goal
    @Published var lastActiveTimestamp: TimeInterval? = nil
    
    var totalSteps: Int {
        stepCount.values.reduce(0, +)
    }

    var totalCalories: Double {
        activeEnergyBurned.values.reduce(0, +)
    }

    var totalDistance: Double {
        distanceWalked.values.reduce(0, +)
    }
    
    var totalMoveTime: Double {
        activeTime.values.reduce(0, +)
    }
    
    var averageWalkingSpeed: Double {
        let totalSpeed = walkingSpeed.values.reduce(0, +)
        return walkingSpeed.isEmpty ? 0 : totalSpeed / Double(walkingSpeed.count)
    }
    
    var averageWalkingStepLength: Double {
        let totalLength = walkingStepLength.values.reduce(0, +)
        return walkingStepLength.isEmpty ? 0 : totalLength / Double(walkingStepLength.count)
    }
    
    var goalPercentage: Double {
        goalSteps > 0 ? Double(totalSteps) / Double(goalSteps) : 0
    }
    
    init() {
        self.healthStore = HKHealthStore()
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
    
    func fetchMetrics() async {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.startOfDay(for: endDate)
        let anchorDate = calendar.startOfDay(for: endDate)
        let interval = DateComponents(hour: 1)
        
        func createQuery(
            for quantityType: HKQuantityType,
            options: HKStatisticsOptions,
            unit: HKUnit
        ) -> HKStatisticsCollectionQuery {
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            let query = HKStatisticsCollectionQuery(
                quantityType: quantityType,
                quantitySamplePredicate: predicate,
                options: options,
                anchorDate: anchorDate,
                intervalComponents: interval
            )

            query.initialResultsHandler = { [weak self] _, results, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching initial results: \(error.localizedDescription)")
                    return
                }

                Task { @MainActor in
                    self.processResults(results, for: quantityType, with: unit, options: options)
                }
            }

            query.statisticsUpdateHandler = { [weak self] _, statistics, _, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error in update handler: \(error.localizedDescription)")
                    return
                }

                guard let statistics = statistics else {
                    print("No statistics available in update handler")
                    return
                }

                Task { @MainActor in
                    self.processStatistics(statistics, for: quantityType, with: unit, options: options)
                }
            }

            return query
        }

        let queries = [
            createQuery(for: .quantityType(forIdentifier: .stepCount)!, options: .cumulativeSum, unit: .count()),
            createQuery(for: .quantityType(forIdentifier: .activeEnergyBurned)!, options: .cumulativeSum, unit: .kilocalorie()),
            createQuery(for: .quantityType(forIdentifier: .distanceWalkingRunning)!, options: .cumulativeSum, unit: .mile()),
            createQuery(for: .quantityType(forIdentifier: .appleMoveTime)!, options: .cumulativeSum, unit: .minute()),
            createQuery(for: .quantityType(forIdentifier: .walkingSpeed)!, options: .discreteAverage, unit: .mile().unitDivided(by: .hour())),
            createQuery(for: .quantityType(forIdentifier: .walkingStepLength)!, options: .discreteAverage, unit: .inch())
        ]

        for query in queries {
            healthStore.execute(query)
        }

//        func createDescriptor(
//            for type: HKQuantityType,
//            options: HKStatisticsOptions) -> HKStatisticsCollectionQueryDescriptor {
//            
//            let samplePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
//            let predicate = HKSamplePredicate.quantitySample(type: type, predicate: samplePredicate)
//            let descriptor = HKStatisticsCollectionQueryDescriptor(
//                predicate: predicate,
//                options: options,
//                anchorDate: anchorDate,
//                intervalComponents: interval
//            )
//                
//            return descriptor
//        }
//        
//        let stepCountDescriptor = createDescriptor(for: .quantityType(forIdentifier: .stepCount)!, options: .cumulativeSum)
//        let activeEnergyBurnedDescriptor = createDescriptor(for: .quantityType(forIdentifier: .activeEnergyBurned)!, options: .cumulativeSum)
//        let distanceWalkedDescriptor = createDescriptor(for: .quantityType(forIdentifier: .distanceWalkingRunning)!, options: .cumulativeSum)
//        let walkingSpeedDescriptor = createDescriptor(for: .quantityType(forIdentifier: .walkingSpeed)!, options: .discreteAverage)
//        
//        let queries: [HKStatisticsCollectionQuery] = [
//            HKStatisticsCollectionQuery(descriptor: stepCountDescriptor),
//            HKStatisticsCollectionQuery(descriptor: activeEnergyBurnedDescriptor),
//            HKStatisticsCollectionQuery(descriptor: distanceWalkedDescriptor),
//            HKStatisticsCollectionQuery(descriptor: walkingSpeedDescriptor)
//        ]
//
//        do {
//            // Execute each query one by one
//            for query in queries {
//                let results = try await healthStore.execute(query)
//                processMetrics(results, for: query)
//            }
//        } catch {
//            print("Error fetching metrics: \(error.localizedDescription)")
//        }

    }

    private func processResults(_ results: HKStatisticsCollection?, for type: HKQuantityType, with unit: HKUnit, options: HKStatisticsOptions) {
        guard let results = results else { return }
        
        // Move each statistic to the main actor context
        for statistics in results.statistics() {
            Task { @MainActor in
                self.processStatistics(statistics, for: type, with: unit, options: options)
                if type == HKQuantityType.quantityType(forIdentifier: .appleMoveTime) {
                    if let value = statistics.sumQuantity()?.doubleValue(for: unit) {
                        print(value)
                    }
                }
            }
        }
    }

    private func processStatistics(_ statistics: HKStatistics, for type: HKQuantityType, with unit: HKUnit, options: HKStatisticsOptions) {
        guard let dateKey = formatDate(statistics.startDate, dateFormat: "HH") else { return }

        if options.contains(.cumulativeSum), let value = statistics.sumQuantity()?.doubleValue(for: unit), value >= 0 {
            updateMetric(for: type, value: value, dateKey: dateKey)
        } else if options.contains(.discreteAverage), let value = statistics.averageQuantity()?.doubleValue(for: unit), value >= 0 {
            updateMetric(for: type, value: value, dateKey: dateKey)
        } else {
            print("Invalid data for \(type.identifier) on \(dateKey)")
        }
    }

    func updateMetric(for type: HKQuantityType, value: Double, dateKey: String?) {
        guard let dateKey = dateKey else { return }

        // Compare `type` against unwrapped quantity types
        if type == HKQuantityType.quantityType(forIdentifier: .stepCount) {
            stepCount[dateKey] = Int(value)
        } else if type == HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
            activeEnergyBurned[dateKey] = value
        } else if type == HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) {
            distanceWalked[dateKey] = value
        } else if type == HKQuantityType.quantityType(forIdentifier: .appleMoveTime) {
            activeTime[dateKey] = value
            print("move time: \(value)")
        } else if type == HKQuantityType.quantityType(forIdentifier: .walkingSpeed) {
            walkingSpeed[dateKey] = value
        } else if type == HKQuantityType.quantityType(forIdentifier: .walkingStepLength) {
            walkingStepLength[dateKey] = value
        } else {
            print("Unhandled metric type: \(type.identifier)")
        }
    }

    private func formatDate(_ date: Date, dateFormat: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat // Set the desired format
        return formatter.string(from: date)
    }
    
    func startTrackingMotion() {
        if CMMotionActivityManager.isActivityAvailable() {
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
}

//        func createQuery(
//            for quantityType: HKQuantityType,
//            options: HKStatisticsOptions,
//            unit: HKUnit
//        ) -> HKStatisticsCollectionQuery {
//            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
//            let query = HKStatisticsCollectionQuery(
//                quantityType: quantityType,
//                quantitySamplePredicate: predicate,
//                options: options,
//                anchorDate: anchorDate,
//                intervalComponents: interval
//            )
//
//            query.initialResultsHandler = { [weak self] _, results, error in
//                guard let self = self else { return }
//                if let error = error {
//                    print("Error fetching initial results: \(error.localizedDescription)")
//                    return
//                }
//
//                Task { @MainActor in
//                    self.processResults(results, for: quantityType, with: unit, options: options)
//                }
//            }
//
//            query.statisticsUpdateHandler = { [weak self] _, statistics, _, error in
//                guard let self = self else { return }
//                if let error = error {
//                    print("Error in update handler: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let statistics = statistics else {
//                    print("No statistics available in update handler")
//                    return
//                }
//
//                Task { @MainActor in
//                    self.processStatistics(statistics, for: quantityType, with: unit, options: options)
//                }
//            }
//
//            return query
//        }
//
//        let queries = [
//            createQuery(for: .quantityType(forIdentifier: .stepCount)!, options: .cumulativeSum, unit: .count()),
//            createQuery(for: .quantityType(forIdentifier: .activeEnergyBurned)!, options: .cumulativeSum, unit: .kilocalorie()),
//            createQuery(for: .quantityType(forIdentifier: .distanceWalkingRunning)!, options: .cumulativeSum, unit: .mile()),
//            createQuery(for: .quantityType(forIdentifier: .appleMoveTime)!, options: .cumulativeSum, unit: .minute()),
//            createQuery(for: .quantityType(forIdentifier: .walkingSpeed)!, options: .discreteAverage, unit: .mile().unitDivided(by: .hour())),
//            createQuery(for: .quantityType(forIdentifier: .walkingStepLength)!, options: .discreteAverage, unit: .inch())
//        ]
//
//        for query in queries {
//            healthStore.execute(query)
//        }
