//
//  HealthKitManager.swift
//  Steps
//
//  Created by Eric Carroll on 8/20/23.
//

import SwiftUI
import HealthKit

final class HealthDataService {
    var store: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore()
        } else {
            print("Health Data not Available")
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
    
    func fetchData (quantityType: HKQuantityTypeIdentifier, startDate: Date, options: HKStatisticsOptions, unit: HKUnit) async -> Double {
        guard let
                quantityType = HKObjectType.quantityType(forIdentifier: quantityType)
        else {
            fatalError("Unable to get the quantity type")
        }

        let calendar = Calendar.current
        let interval = DateComponents(hour: 24)

        guard let
            anchorDate = calendar.date(bySettingHour: 0, minute: 0, second: 1, of: Date())
        else {
            fatalError()
        }

        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: nil,
            options: options,
            anchorDate: anchorDate,
            intervalComponents: interval
        )

        return await withCheckedContinuation { continuation in
            
            var value = 0.0
            
            query.initialResultsHandler = { query, collection, error in
                guard let
                    result = collection
                else {
                    continuation.resume(returning: 0.0)
                    return
                }

                result.enumerateStatistics(from: .startOfDay, to: Date()) { statistics, stop in
                    value = (statistics.sumQuantity()?.doubleValue(for: unit) ?? 0.0)
                }
                
                continuation.resume(returning: value)
            }
            
            query.statisticsUpdateHandler = {query, statistics, collection, error in
                guard let
                    statistics = statistics
                else {
                    continuation.resume(returning: 0.0)
                    return
                }
                
                value = statistics.sumQuantity()?.doubleValue(for: unit) ?? 0.0
//                collection.enumerateStatistics(from: .startOfDay, to: Date()){ (statistics, stop) in
//                    value = (statistics.sumQuantity()?.doubleValue(for: unit) ?? 0.0)
//                }
            }

            store!.execute(query)
        }
    }
    
    @MainActor
    func fetchStepChartData(startDate: Date) async -> [Step] {
        guard let
            quantityType = HKObjectType.quantityType(forIdentifier: .stepCount)
        else {
            fatalError("Unable to get the step count type")
        }

        let calendar = Calendar.current
        let interval = DateComponents(hour: 1)

        guard let
            anchorDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
        else {
            fatalError()
        }

        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: interval
        )

        return await withCheckedContinuation {continuation in
            query.initialResultsHandler = { query, result, error in
                guard let
                    result = result
                else {
                    continuation.resume(returning: [])
                    return
                }

                var hourlySteps = [Step]()

                result.enumerateStatistics(from: .startOfDay, to: Date()) { statistics, stop in
                    hourlySteps.append(Step(date: statistics.startDate, count: statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.00))
                }

                continuation.resume(returning: hourlySteps)
            }

            query.statisticsUpdateHandler = {query, statistics, collection, error in
                guard let
                    collection = collection
                else {
                    continuation.resume(returning: [])
                    return
                }

                var hourlySteps = [Step]()

                collection.enumerateStatistics(from: .startOfDay, to: Date()){ (statistics, stop) in
                    hourlySteps.append(Step(date: statistics.startDate, count: statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.00))
                }
            }

            store!.execute(query)
        }
    }
    
//    func fetchWeeklySteps() async throws -> [Step] {
//        // Create a predicate for this week's samples.
//        var steps = [Step]()
//        let calendar = Calendar(identifier: .gregorian)
//        let today = calendar.startOfDay(for: Date())
//        
//        guard let endDate = calendar.date(byAdding: .day, value: 1, to: today) else {
//            fatalError("*** Unable to calculate the end time ***")
//        }
//        
//        guard let startDate = calendar.date(byAdding: .day, value: -7, to: endDate) else {
//             fatalError("*** Unable to calculate the start time ***")
//        }
//        
//        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
//        
//        // Create the query descriptor.
//        let quantityType = HKQuantityType(.stepCount)
//        let samplePredicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: thisWeek)
//        let everyDay = DateComponents(day: 1)
//
//        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(
//            predicate: samplePredicate,
//            options: .cumulativeSum,
//            anchorDate: endDate,
//            intervalComponents: everyDay)
//
//        let statistics = try await sumOfStepsQuery.result(for: healthStore!)
//        
//        statistics.enumerateStatistics(from: startDate, to: endDate) { results, _ in
//            if let quantity = results.sumQuantity() {
//                let date = results.startDate
//                let value = quantity.doubleValue(for: .count())
//                        
//                steps.append(Step(date: date, count: value))
//            }
//        }
//        
//        return steps
//    }
    
//    func fetchWeeklyDistanceWalkingRunning(distance: inout Double) async throws {
//        // Create a predicate for this week's samples.
//        var miles = [Distance]()
//        let calendar = Calendar(identifier: .gregorian)
//        let today = calendar.startOfDay(for: Date())
//        
//        guard let endDate = calendar.date(byAdding: .day, value: 1, to: today) else {
//            fatalError("*** Unable to calculate the end time ***")
//        }
//        
//        guard let startDate = calendar.date(byAdding: .day, value: -7, to: endDate) else {
//             fatalError("*** Unable to calculate the start time ***")
//        }
//        
//        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
//        
//        // Create the query descriptor.
//        let quantityType = HKQuantityType(.distanceWalkingRunning)
//        let samplePredicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: thisWeek)
//        let everyDay = DateComponents(day: 1)
//
//        let sumOfDistanceQuery = HKStatisticsCollectionQueryDescriptor(
//            predicate: samplePredicate,
//            options: .cumulativeSum,
//            anchorDate: endDate,
//            intervalComponents: everyDay)
//
////        let statistics = try await sumOfDistanceQuery.result(for: healthStore!)
//        let stats = sumOfDistanceQuery.results(for: healthStore!)
//        
////        statistics.enumerateStatistics(from: startDate, to: endDate) { results, _ in
////            if let quantity = results.sumQuantity() {
////                let date = results.startDate
////                let value = quantity.doubleValue(for: .mile())
////                        
////                miles.append(Distance(date: date, count: value))
////            }
////        }
//        
//        for try await results in stats {
//            results.statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
//                
//                if let quantity = statistics.sumQuantity() {
//                    let date = statistics.startDate
//                    let value = quantity.doubleValue(for: .mile())
//                    
//                    if !miles.isEmpty {
//                        miles.removeAll()
//                    } else {
//                        miles.append(Distance(date: date, count: value))
//                        
//                    }
//                }
//            }
//        }
//        
//        distance = miles.last?.count ?? 0.0
//
////        print(miles.last?.count ?? 99)
////        return miles
//    }
    
    @MainActor
    func test(quantityType: HKQuantityTypeIdentifier, startDate: Date, options: HKStatisticsOptions, unit: HKUnit) async throws {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: quantityType) else { fatalError("Unable to get the quantity type") }
        
        let predicate = HKQuery.predicateForSamples(withStart: Date.startOfDay, end: nil, options: [.strictStartDate])
        let samplePredicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: predicate)
        let descriptor = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate, options: options, anchorDate: Date.startOfDay, intervalComponents: DateComponents(hour: 1))
        
        let updateQueue = descriptor.results(for: store!)
        
        Task {
            var total = 0.0
            for try await results in updateQueue {
                results.statisticsCollection.enumerateStatistics(from: Date.startOfDay, to: Date.now) { statistics, _ in
                    let value = statistics.sumQuantity()?.doubleValue(for: unit)
                    total += value ?? 0.0
                    print(Calendar.current.dateComponents([.day],from: statistics.startDate), Calendar.current.dateComponents([.hour],from: statistics.startDate), Int(value ?? 0), Int(total))
                }
            }
        }
    }
}



