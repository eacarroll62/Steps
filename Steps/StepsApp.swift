//
//  StepsApp.swift
//  Steps
//
//  Created by Eric Carroll on 8/20/23.
//

import SwiftUI
import SwiftData

@main
struct StepsApp: App {
    @StateObject private var appContainer: AppContainer

    init() {
        // Attempt to initialize the main AppContainer
        do {
            let container = try AppContainer()
            _appContainer = StateObject(wrappedValue: container)
        } catch {
            print("Failed to initialize AppContainer: \(error.localizedDescription)")
            // Use the fallback initializer
            _appContainer = StateObject(wrappedValue: AppContainer(fallback: true))
        }
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appContainer.settingsManager)
                .environmentObject(appContainer.healthKitManager)
                .onAppear {
                    setupAsyncTasks()
                }
        }
    }

    private func setupAsyncTasks() {
        Task {
            await appContainer.healthKitManager.requestAuthorization()
        }
    }
}

//struct StepsApp: App {
//    @StateObject private var settingsManager = SettingsManager()
//    @StateObject private var healthKitManager: HealthKitManager
//    private let modelContainer: ModelContainer
//    private let dataManager: DataManager
//
//    init() {
//        // Initialize ModelContainer
//        do {
//            modelContainer = try ModelContainer(for: DailyStats.self)
//        } catch {
//            fatalError("Failed to initialize ModelContainer: \(error)")
//        }
//        
//        // Initialize DataManager with the modelContext
//        dataManager = DataManager(modelContext: modelContainer.mainContext)
//        
//        let healthKitManager = HealthKitManager(dataManager: dataManager)
//        _healthKitManager = StateObject(wrappedValue: healthKitManager)
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            MainView()
//                .environmentObject(settingsManager)
//                .environmentObject(healthKitManager)
//                .environment(\.dataManager, dataManager) // Inject DataManager into the environment
//        }
//        .modelContainer(modelContainer) // Set up the model container for SwiftData
//    }
//}
