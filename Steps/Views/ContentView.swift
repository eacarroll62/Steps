//
//  ContentView.swift
//  Steps
//
//  Created by Eric Carroll on 8/20/23.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @Environment(HealthDataViewModel.self) var viewModel
    @State private var showSettings: Bool = false
    @AppStorage("stepGoal") private var stepGoal: Int = 10000
    @AppStorage("darkMode") private var darkModeEnabled: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ProgressCircle(viewModel: viewModel)
                DisplayChartOrListView()
                InfoDashboardView(viewModel: viewModel)
            }
            .task {
                Settings.shared.handleUserSettings(stepGoal: stepGoal)
                Settings.shared.handleDisplaySettings(darkMode: darkModeEnabled)
                await viewModel.requestAuthorization()
                do {
                    try await viewModel.fetchStepCountData()
                    try await viewModel.fetchDistanceWalkingRunningData()
                    try await viewModel.fetchActiveEnergyBurnedData()
                    try await viewModel.fetchAppleMoveTimeData()
                    try await viewModel.fetchWalkingStepLengthData()
                    try await viewModel.fetchWalkingSpeedData()
                    try await viewModel.fetchAllStepData()
                } catch {
                    print(error.localizedDescription)
                }
                
                do {
                    try await viewModel.enableBackgroundDelivery()
                } catch {
                    print(error.localizedDescription)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {showSettings.toggle()}, label: {
                            Text("Settings...")
                        })
                    } label: {
                        Image(systemName: "gearshape").padding()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                }
            }
            .sheet(isPresented: $showSettings, content: { SettingsView( stepGoal: $stepGoal, darkModeEnabled: $darkModeEnabled) })
        }
    }
}

#Preview("Main View") {
    NavigationStack {
        ContentView()
            .environment(HealthDataViewModel())
    }
}




