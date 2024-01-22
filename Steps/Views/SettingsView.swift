//
//  SettingsView.swift
//  Steps
//
//  Created by Eric Carroll on 9/10/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(HealthDataViewModel.self) private var viewModel
    @Binding var stepGoal: Int

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Step Goal")) {
                    VStack(alignment: .leading) {
                        TextField("Goal:", value: $stepGoal, format: .number)
                            .onChange(of: stepGoal) {
                                viewModel.healthData.stepGoal = stepGoal
                            }
                            .keyboardType(.numberPad)
                    }
                }
                
            }
            VStack {
                Button("Dismiss", role: .destructive) { dismiss() }
                    .buttonStyle(.borderedProminent)
            }.navigationTitle("Settings")
        }
    }
}

#Preview("SettingsView") {
    SettingsView(stepGoal: .constant(15000))
        .environment(HealthDataViewModel())
}