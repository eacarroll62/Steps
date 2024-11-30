//
//  StepsApp.swift
//  Steps
//
//  Created by Eric Carroll on 8/20/23.
//

import SwiftUI

@main
struct StepsApp: App {
    @StateObject private var healthKitManager = HealthKitManager()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(healthKitManager)  // Inject HealthKitManager into the environment
        }
    }
}
