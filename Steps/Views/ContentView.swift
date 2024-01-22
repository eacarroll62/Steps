//
//  ContentView.swift
//  Steps
//
//  Created by Eric Carroll on 8/20/23.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    @State private var showSettings: Bool = false
    @State private var displayType: DisplayType = .chart
    @Environment(HealthDataViewModel.self) var viewModel
    @AppStorage("stepGoal") private var stepGoal: Int = 10000
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.black).ignoresSafeArea(.all)
                VStack(alignment: .leading) {
                    ProgressCircle(viewModel: viewModel)
                    Group {
                        switch displayType {
                            case .list:
                                ListView(viewModel: viewModel)
                            case .chart:
                                ChartView(viewModel: viewModel)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Picker("Selection", selection: $displayType) {
                        ForEach(DisplayType.allCases) { displayType in
                            Image(systemName: displayType.icon).tag(displayType)
                        }
                    }
                    .pickerStyle(.segmented)
                    .background(Color.green)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    InfoDashboardView(viewModel: viewModel)
                }
            }
            .task {
                Settings.shared.handleSettings(stepGoal: stepGoal)
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
            .sheet(isPresented: $showSettings, content: { SettingsView( stepGoal: $stepGoal) })
        }
    }
}

#Preview("Main View") {
    NavigationStack {
        ContentView()
            .environment(HealthDataViewModel())
    }
}




