//
//  SettingsView.swift
//  Steps
//
//  Created by Eric Carroll on 9/10/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var settingsManager: SettingsManager
    
    @Binding var showSettings: Bool
    
    var body: some View {
        VStack {
            // Goal Steps Section
            VStack(alignment: .leading, spacing: 20) {
                Text("Set Goal Steps")
                    .font(.headline)
                
                Stepper(value: $healthKitManager.goalSteps, in: 0...100000, step: 100) {
                    Text("Goal Steps: \(healthKitManager.goalSteps)")
                }
                .padding()
            }

            // Dark Mode Toggle Section
            VStack(alignment: .leading, spacing: 20) {
                Text("Appearance")
                    .font(.headline)
                
                Toggle(isOn: $settingsManager.isDarkMode) {
                    Text("Dark Mode")
                }
                .padding()
            }
            
            // Reset Dark Mode to system default
            Button("Reset Dark Mode to System") {
                settingsManager.resetDarkMode()
            }
            .padding()

            // Close Button
            Button(action: {
                showSettings.toggle()
            }) {
                Text("Close")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

//#Preview("SettingsView") {
//    SettingsView(showSettings: .constant(false))
//        .environmentObject(HealthKitManager())
//        .environmentObject(SettingsManager())
//}
