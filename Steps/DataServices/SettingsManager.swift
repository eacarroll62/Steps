//
//  SettingsManager.swift
//  Steps
//
//  Created by Eric Carroll on 11/22/24.
//

import Foundation
import SwiftUI

@MainActor
class SettingsManager: ObservableObject {
    @Published var goalSteps: Int {
        didSet {
            saveGoalSteps() // Persist changes when `goalSteps` is updated
        }
    }
    @Published var isDarkMode: Bool

    init() {
        // Load goalSteps from UserDefaults or set a default value
        if let storedGoalSteps = UserDefaults.standard.object(forKey: "goalSteps") as? Int {
            self.goalSteps = storedGoalSteps
        } else {
            self.goalSteps = 10_000
            UserDefaults.standard.set(10_000, forKey: "goalSteps")
        }

        // Load isDarkMode from UserDefaults or set a default value
        if let storedDarkMode = UserDefaults.standard.value(forKey: "isDarkMode") as? Bool {
            self.isDarkMode = storedDarkMode
        } else {
            self.isDarkMode = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        }
    }

    /// Saves the current goalSteps value to UserDefaults
    private func saveGoalSteps() {
        UserDefaults.standard.set(goalSteps, forKey: "goalSteps")
    }

    /// Resets dark mode to the system's default setting
    func resetDarkMode() {
        self.isDarkMode = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
    }
}
