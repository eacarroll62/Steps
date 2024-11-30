//
//  MainView.swift
//  Steps
//
//  Created by Eric Carroll on 11/20/24.
//

import SwiftUI
import Charts

struct MainView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State private var showSettings: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .center, spacing: 10) {
                    InfoDashboardView()
                    ProgressCircle().padding()
                    ChartView()
                }
                .padding()
                
            }
                .navigationBarTitle("Health Metrics")
                .navigationBarItems(trailing:
                    Button(action: {showSettings.toggle()}) {
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                    })
                .sheet(isPresented: $showSettings) {
                    // Settings View - will appear from the bottom
                    SettingsView(showSettings: $showSettings)
                }
                .onAppear {
                    Task {
                        await healthKitManager.requestAuthorization()
                        await healthKitManager.fetchMetrics()
                    }
                }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(HealthKitManager())
}
