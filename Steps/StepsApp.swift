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

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
