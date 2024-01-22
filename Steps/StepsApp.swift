//
//  StepsApp.swift
//  Steps
//
//  Created by Eric Carroll on 8/20/23.
//

import SwiftUI

@main
struct StepsApp: App {
    @State private var viewModel = HealthDataViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(viewModel)
    }
}
