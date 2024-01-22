//
//  HealthStatsViewModel.swift
//  Steps
//
//  Created by Eric Carroll on 12/14/23.
//

import SwiftUI
import Observation
import HealthKit

enum HealthDataError: Error {
    case couldNotFetchHealthStore
    case unableToGetQuantityType
}

@Observable
class HealthDataViewModel {
    var store: HKHealthStore?
    var error: Error?
    var healthData: HealthDataModel = HealthDataModel()
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore()
        } else {
            error = HealthDataError.couldNotFetchHealthStore
        }
    }
    
    public func requestAuthorization() async {
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .walkingSpeed)!,
            HKQuantityType.quantityType(forIdentifier: .walkingStepLength)!,
            HKQuantityType.quantityType(forIdentifier: .appleMoveTime)!,
            HKObjectType.activitySummaryType()
        ]
        
        guard let store = self.store else { return }
        
        do {
            try await store.requestAuthorization(toShare: [], read: typesToRead)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func enableBackgroundDelivery() async throws {
        try await store?.enableBackgroundDelivery(for: .activitySummaryType(), frequency: .hourly)
    }
    
    @MainActor
    public func fetchStepCountData() async throws {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else { throw HealthDataError.unableToGetQuantityType }
        
        let predicate = HKQuery.predicateForSamples(withStart: Date.startOfDay, end: nil, options: [.strictStartDate])
        let samplePredicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: predicate)
        let descriptor = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate, options: .cumulativeSum, anchorDate: Date(), intervalComponents: DateComponents(hour: 24))
        
        let updateQueue = descriptor.results(for: store!)
        
        Task {
            for try await results in updateQueue {
                results.statisticsCollection.enumerateStatistics(from: Date.startOfDay, to: Date.now) { statistics, _ in
                    if let value = statistics.sumQuantity()?.doubleValue(for: .count()) {
                        if value > 0.0 {
                            print("Steps: ", value)
                            self.healthData.stepCount = Int(value)
                        }
                    }
                }
            }
        }
    }
    
    @MainActor
    public func fetchDistanceWalkingRunningData() async throws {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else { throw HealthDataError.unableToGetQuantityType }
        
        let predicate = HKQuery.predicateForSamples(withStart: Date.startOfDay, end: nil, options: [.strictStartDate])
        let samplePredicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: predicate)
        let descriptor = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate, options: .cumulativeSum, anchorDate: Date.startOfDay, intervalComponents: DateComponents(hour: 1))
        
        let updateQueue = descriptor.results(for: store!)
        
        Task {
            for try await results in updateQueue {
                results.statisticsCollection.enumerateStatistics(from: Date.startOfDay, to: Date.now) { statistics, _ in
                    if let value = statistics.sumQuantity()?.doubleValue(for: .mile()) {
                        if value > 0.0 {
                            self.healthData.distanceWalkingRunning = value
                        }
                    }
                }
            }
        }
    }
    
    @MainActor
    public func fetchActiveEnergyBurnedData() async throws {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else { throw HealthDataError.unableToGetQuantityType }
        
        let predicate = HKQuery.predicateForSamples(withStart: Date.startOfDay, end: nil, options: [.strictStartDate])
        let samplePredicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: predicate)
        let descriptor = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate, options: .cumulativeSum, anchorDate: Date.startOfDay, intervalComponents: DateComponents(hour: 1))
        
        let updateQueue = descriptor.results(for: store!)
        
        Task {
            for try await results in updateQueue {
                results.statisticsCollection.enumerateStatistics(from: Date.startOfDay, to: Date.now) { statistics, _ in
                    if let value = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) {
                        if value > 0.0 {
                            self.healthData.activeEnergyBurned = value
                        }
                    }
                }
            }
        }
    }
    
    @MainActor
    public func fetchAppleMoveTimeData() async throws {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .appleMoveTime) else { throw HealthDataError.unableToGetQuantityType }
        
        let predicate = HKQuery.predicateForSamples(withStart: Date.startOfDay, end: nil, options: [.strictStartDate])
        let samplePredicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: predicate)
        let descriptor = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate, options: .cumulativeSum, anchorDate: Date.startOfDay, intervalComponents: DateComponents(hour: 1))
        
        let updateQueue = descriptor.results(for: store!)
        
        Task {
            for try await results in updateQueue {
                results.statisticsCollection.enumerateStatistics(from: Date.startOfDay, to: Date.now) { statistics, _ in
                    if let value = statistics.sumQuantity()?.doubleValue(for: .minute()) {
                        if value > 0.0 {
                            self.healthData.appleMoveTime = value
                        }
                    }
                }
            }
        }
    }
    
    @MainActor
    public func fetchWalkingStepLengthData() async throws {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .walkingStepLength) else { throw HealthDataError.unableToGetQuantityType }
        
        let predicate = HKQuery.predicateForSamples(withStart: Date.startOfDay, end: nil, options: [.strictStartDate])
        let samplePredicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: predicate)
        let descriptor = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate, options: .discreteAverage, anchorDate: Date.startOfDay, intervalComponents: DateComponents(hour: 1))
        
        let updateQueue = descriptor.results(for: store!)
        
        Task {
            for try await results in updateQueue {
                results.statisticsCollection.enumerateStatistics(from: Date.startOfDay, to: Date.now) { statistics, _ in
                    if let value = statistics.sumQuantity()?.doubleValue(for: .inch()) {
                        if value > 0.0 {
                            self.healthData.walkingStepLength = value
                        }
                    }
                }
            }
        }
    }
    
    @MainActor
    public func fetchWalkingSpeedData() async throws {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .walkingSpeed) else { throw HealthDataError.unableToGetQuantityType }
        
        let predicate = HKQuery.predicateForSamples(withStart: Date.startOfDay, end: nil, options: [.strictStartDate])
        let samplePredicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: predicate)
        let descriptor = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate, options: .discreteAverage, anchorDate: Date.startOfDay, intervalComponents: DateComponents(hour: 1))
        
        let updateQueue = descriptor.results(for: store!)
        
        Task {
            for try await results in updateQueue {
                results.statisticsCollection.enumerateStatistics(from: Date.startOfDay, to: Date.now) { statistics, _ in
                    if let value = statistics.sumQuantity()?.doubleValue(for: .mile().unitDivided(by: .hour())) {
                        if value > 0.0 {
                            self.healthData.walkingSpeed = value
                        }
                    }
                }
            }
        }
    }

    @MainActor
    public func fetchAllStepData() async throws {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else { throw HealthDataError.unableToGetQuantityType }
        
        let predicate = HKQuery.predicateForSamples(withStart: Date.startOfDay, end: nil, options: [.strictStartDate])
        let samplePredicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: predicate)
        let descriptor = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate, options: .cumulativeSum, anchorDate: Date.startOfDay, intervalComponents: DateComponents(hour: 1))
        
        let updateQueue = descriptor.results(for: store!)
        
        Task {
            for try await results in updateQueue {
                results.statisticsCollection.enumerateStatistics(from: Date.startOfDay, to: Date.now) { statistics, _ in
                    if let value = statistics.sumQuantity()?.doubleValue(for: .count()) {
                        if value > 0 {
                            self.healthData.allStepData.append(Step(date: statistics.startDate, count: value))
                        }
                    }
                }
            }
        }
    }
}
