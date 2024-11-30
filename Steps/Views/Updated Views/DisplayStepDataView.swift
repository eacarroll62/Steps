//
//  DisplayStepDataView.swift
//  Steps
//
//  Created by Eric Carroll on 1/21/24.
//

import SwiftUI

struct DisplayStepDataView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Goal: \(healthKitManager.goalSteps)")
                .font(.title3)
                .bold()
            
            Text("\(healthKitManager.totalSteps)")
                .monospaced()
                .font(.system(size: 50))
                .contentTransition(.numericText())

            Text("\((100.0 * healthKitManager.goalPercentage).formattedString(2))% Completed!")
        }
        .monospaced()
        .bold()
        .offset(y: -20)
        .font(.system(size: 20))
        .foregroundColor(.gray)
        .onAppear {
            Task {
                await healthKitManager.fetchMetrics()  // Fetch steps when view appears
            }
        }
    }
}

#Preview {
    DisplayStepDataView()
        .environmentObject(HealthKitManager())
}
