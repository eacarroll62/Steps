//
//  Settings.swift
//  Steps
//
//  Created by Eric Carroll on 10/29/23.
//

import SwiftUI

class Settings {
    @State private var viewModel: HealthDataViewModel = HealthDataViewModel()
    static let shared = Settings()
    
    private init() {}
    
    func handleUserSettings(stepGoal: Int) {
        viewModel.healthData.stepGoal = stepGoal
    }
    
    func handleDisplaySettings(darkMode: Bool) {
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = darkMode ? .dark : .light
    }
}
