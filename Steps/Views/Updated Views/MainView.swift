//
//  MainView.swift
//  Steps
//
//  Created by Eric Carroll on 11/20/24.
//

import SwiftUI
import Charts
import WidgetKit

struct MainView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State private var showSettings: Bool = false
    
    private var upperDataItemsSet: [DataItem] {
        [
            DataItem(
                imageName: "flame.fill",
                imageColor: .red,
                value: healthKitManager.totalCalories.formattedString(2),
                unit: "kcal",
                accessibilityHint: "Total Calories Burned"
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
                value: healthKitManager.totalMoveTime.formattedString(0),
                unit: "mins",
                accessibilityHint: "Active Time"
            )
        ]
    }

    private var lowerDataItemsSet: [DataItem] {
        [
            DataItem(
                imageName: "ruler",
                imageColor: .purple,
                value: healthKitManager.averageWalkingStepLength.formattedString(1),
                unit: "inches",
                accessibilityHint: "Average Step Length"
            ),
            DataItem(
                imageName: "speedometer",
                imageColor: .crimson,
                value: healthKitManager.averageWalkingSpeed.formattedString(1),
                unit: "mph",
                accessibilityHint: "Average Walking Speed"
            ),
            DataItem(
                imageName: "figure.stairs",
                imageColor: .orange,
                value: healthKitManager.totalFlightsClimbed.formattedString(),
                unit: "flights",
                accessibilityHint: "Flights Climbed"
            )
        ]
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 10) {
                InfoDashboardView(dataItems: upperDataItemsSet).padding()
                ProgressCircle()
                InfoDashboardView(dataItems: lowerDataItemsSet).padding()
                ChartView()
            }
            .padding()
            .navigationBarTitle("Health Metrics")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button(action: {showSettings.toggle()}) {
                    Image(systemName: "gearshape.fill")
                    .font(.caption)
                    .tint(.green)
            })
            .sheet(isPresented: $showSettings) {
                // Settings View - will appear from the bottom
                SettingsView(showSettings: $showSettings)
            }
            .onAppear {
                Task {
                    await healthKitManager.requestAuthorization()
                    await healthKitManager.startTrackingMetrics(for: Date.now)
                }
                healthKitManager.saveStepsToSharedStorage(goalSteps: healthKitManager.goalSteps, totalSteps: healthKitManager.totalSteps)
                print("Saving goalSteps: \(healthKitManager.goalSteps), totalSteps: \(healthKitManager.totalSteps)")
                WidgetCenter.shared.reloadAllTimelines()
            }
            .onChange(of: healthKitManager.totalSteps) {
                healthKitManager.saveStepsToSharedStorage(goalSteps: healthKitManager.goalSteps, totalSteps: healthKitManager.totalSteps)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}

//#Preview {
//    MainView()
//        .environmentObject(HealthKitManager())
//}
