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
    // Properties that will be persisted in UserDefaults
    @Published var goalSteps: Int {
        didSet {
            // Save to UserDefaults whenever goalSteps is updated
            UserDefaults.standard.set(goalSteps, forKey: "goalSteps")
        }
    }

    @Published var isDarkMode: Bool {
        didSet {
            // Save to UserDefaults whenever isDarkMode is updated
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }

    // Initialize with default values or saved ones
    init() {
        self.goalSteps = UserDefaults.standard.integer(forKey: "goalSteps")
        // Set default value if no stored preference
        if let storedDarkMode = UserDefaults.standard.value(forKey: "isDarkMode") as? Bool {
            self.isDarkMode = storedDarkMode
        } else {
            // Default to system color scheme
            self.isDarkMode = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        }
    }

    // Reset the dark mode setting to the system setting
    func resetDarkMode() {
        // Set isDarkMode to the current system color scheme
        self.isDarkMode = UIScreen.main.traitCollection.userInterfaceStyle == .dark
    }
}

