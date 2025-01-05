//
//  DataItemViewModel.swift
//  Steps
//
//  Created by Eric Carroll on 1/5/25.
//

import Foundation

class DataItemViewModel: ObservableObject {
    @Published var dataItems: [DataItem] = []

    @MainActor func updateDataItems(using healthKitManager: HealthKitManager, dailyStats: DailyStats?) {
        dataItems = [
            DataItem(
                imageName: "flame.fill",
                imageColor: .red,
                value: healthKitManager.totalCalories.formattedString(2),
                unit: "kcal",
                accessibilityHint: nil
            ),
            DataItem(
                imageName: "figure.walk",
                imageColor: .blue,
                value: healthKitManager.totalDistance.formattedString(2),
                unit: "miles",
                accessibilityHint: "Total Distance Walked"
            ),
            DataItem(
                imageName: "stopwatch.fill",
                imageColor: .green,
                value: (dailyStats?.activeTime ?? healthKitManager.totalMoveTime / 60).formattedString(2),
                unit: "mins",
                accessibilityHint: nil
            ),
            DataItem(
                imageName: "ruler",
                imageColor: .purple,
                value: healthKitManager.averageWalkingStepLength.formattedString(1),
                unit: "inches",
                accessibilityHint: nil
            ),
            DataItem(
                imageName: "speedometer",
                imageColor: .crimson,
                value: healthKitManager.averageWalkingSpeed.formattedString(2),
                unit: "mph",
                accessibilityHint: nil
            )
        ]
    }
}
