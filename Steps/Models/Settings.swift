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
    
    func handleSettings(stepGoal: Int) {
        viewModel.healthData.stepGoal = stepGoal
    }
}
