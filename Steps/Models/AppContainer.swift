//
//  AppClass.swift
//  Steps
//
//  Created by Eric Carroll on 1/12/25.
//

import SwiftData
import SwiftUI

@MainActor
final class AppContainer: ObservableObject {
    let settingsManager: SettingsManager
    let healthKitManager: HealthKitManager
    let modelContainer: ModelContainer
    let dataManager: DataManager

    // Main initializer
    init() throws {
        // Attempt to create a valid ModelContainer
        modelContainer = try ModelContainer(for: DailyStats.self)

        // Initialize dependent components with the created container
        dataManager = DataManager(modelContext: modelContainer.mainContext)
        settingsManager = SettingsManager()
        healthKitManager = HealthKitManager(dataManager: dataManager)
    }

    // Fallback initializer
    init(fallback: Bool) {
        // Create a fallback ModelContainer
        modelContainer = try! ModelContainer(for: DailyStats.self)

        // Use the fallback container to initialize dependencies
        dataManager = DataManager(modelContext: modelContainer.mainContext)
        settingsManager = SettingsManager()
        healthKitManager = HealthKitManager(dataManager: dataManager)
    }
}
