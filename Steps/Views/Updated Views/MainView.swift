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
    
    let upperDataItemsSet: [DataItem] = [
        DataItem(imageName: "flame.fill", imageColor: .red, value: "150", unit: "kcal", accessibilityHint: nil),
        DataItem(imageName: "figure.walk", imageColor: .blue, value: "2.5", unit: "miles", accessibilityHint: "Distance Walked"),
        DataItem(imageName: "stopwatch.fill", imageColor: .green, value: "30", unit: "mins", accessibilityHint: "Active Time")
    ]

    let lowerDataItemsSet: [DataItem] = [
        DataItem(imageName: "ruler", imageColor: .purple, value: "28", unit: "inches", accessibilityHint: nil),
        DataItem(imageName: "speedometer", imageColor: .crimson, value: "3.2", unit: "mph", accessibilityHint: "Average Speed"),
        DataItem(imageName: "waveform.path.ecg", imageColor: .orange, value: "65", unit: "bpm", accessibilityHint: "Heart Rate")
    ]
    
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
