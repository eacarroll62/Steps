//
//  InfoDashboardView.swift
//  Steps
//
//  Created by Eric Carroll on 8/20/23.
//

import SwiftUI

struct InfoDashboardView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @Environment(\.dataManager) private var dataManager
    
    @StateObject private var viewModel = DataItemViewModel()
    @State private var dailyStats: DailyStats?
    
    let dataItems: [DataItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(dataItems) { item in
                    DataItemView(
                        dataItem: DataItem(
                            imageName: item.imageName,
                            imageColor: item.imageColor,
                            value: item.value,
                            unit: item.unit, accessibilityHint: item.accessibilityHint
                        )
                    )
                    .padding(.horizontal)
                    .accessibilityHint(item.accessibilityHint ?? "")
                }
            }
        }
        .onAppear {
            Task {
                await healthKitManager.startTrackingMetrics(for: Date.now) // Trigger your data fetching here
            }

            dataManager?.saveDailyStats(
                steps: healthKitManager.totalSteps,
                distance: healthKitManager.totalDistance,
                calories: healthKitManager.totalCalories,
                walkingSpeed: healthKitManager.averageWalkingSpeed,
                walkingStepLength: healthKitManager.averageWalkingStepLength,
                activeTime: healthKitManager.totalMoveTime,
                stepGoal: healthKitManager.goalSteps
            )

            if let stats = dataManager?.fetchDailyStats(for: Date.now) {
                dailyStats = stats
                print("Active Time: \(stats.activeTime)")
                print("Steps: \(stats.steps)")
            }

            // Update the dashboard items
            viewModel.updateDataItems(using: healthKitManager, dailyStats: dailyStats)
        }
    }
}

//struct InfoDashboardView: View {
//    @EnvironmentObject var healthKitManager: HealthKitManager
//    @Environment(\.dataManager) private var dataManager
//    
//    @State private var dailyStats: DailyStats?
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                DataItemView(dataItem: DataItem(imageName: "flame.fill", imageColor: Color.red, value: healthKitManager.totalCalories.formattedString(2), unit: "kcal", accessibilityHint: "Calories Burned")).padding()
//
//                DataItemView(dataItem: DataItem(imageName: "figure.walk", imageColor: Color.blue, value: healthKitManager.totalDistance.formattedString(2), unit: "miles", accessibilityHint: "Distance Walked")).padding()
//
//                DataItemView(dataItem: DataItem(imageName: "stopwatch.fill", imageColor: Color.green, value: (dailyStats?.activeTime ?? healthKitManager.totalMoveTime / 60).formattedString(2), unit: "mins", accessibilityHint: "Activity Time")).padding(5)
//
//                DataItemView(dataItem: DataItem(imageName: "ruler", imageColor: Color.purple, value: healthKitManager.averageWalkingStepLength.formattedString(1), unit: "inches", accessibilityHint: "Step Length")).padding(5)
//                
//                DataItemView(dataItem: DataItem(imageName: "speedometer", imageColor: Color.crimson, value: healthKitManager.averageWalkingSpeed.formattedString(2), unit: "mph", accessibilityHint: "Walking Speed")).padding()
//            }
//        }
//        .onAppear {
//            Task {
//                await healthKitManager.startTrackingMetrics(for: Date.now)  // Trigger your data fetching here
//            }
//            
//            healthKitManager.startTrackingMotion()
//            
//            dataManager?.saveDailyStats(
//                steps: healthKitManager.totalSteps,
//                distance: healthKitManager.totalDistance,
//                calories: healthKitManager.totalCalories,
//                walkingSpeed: healthKitManager.averageWalkingSpeed,
//                walkingStepLength: healthKitManager.averageWalkingStepLength,
//                activeTime: healthKitManager.totalMoveTime,
//                stepGoal: healthKitManager.goalSteps
//            )
//            
//            if let stats = dataManager?.fetchDailyStats(for: Date.now) {
//                dailyStats = stats
//                print("Active Time: \(stats.activeTime)")
//                print("Steps: \(stats.steps)")
//            }
//        }
//    }
//}

//#Preview {
//    InfoDashboardView(dataItems: [DataItem(imageName: "flame.fill", imageColor: Color.red, value: "500", unit: "kcal", accessibilityHint: "Calories"), DataItem(imageName: "figure.walk", imageColor: Color.blue, value: "5.2", unit: "miles", accessibilityHint: "Distance Walked"), DataItem(imageName: "stopwatch.fill", imageColor: Color.green, value: "210", unit: "mins", accessibilityHint: "Activity Time")])
//        .environmentObject(HealthKitManager())
//}
