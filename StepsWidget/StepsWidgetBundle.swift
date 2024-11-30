//
//  StepsWidgetBundle.swift
//  StepsWidget
//
//  Created by Eric Carroll on 11/18/24.
//

import WidgetKit
import SwiftUI

@main
struct StepsWidgetBundle: WidgetBundle {
    @StateObject private var healthKitManager = HealthKitManager()
    
    var body: some Widget {
        StepsWidget()
    }
}
