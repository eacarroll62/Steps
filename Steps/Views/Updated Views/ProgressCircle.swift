//
//  TestView.swift
//  Steps
//
//  Created by Eric Carroll on 9/9/23.
//

import SwiftUI
import HealthKit

struct ProgressCircle: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject var healthKitManager: HealthKitManager
    @StateObject var settingsManager = SettingsManager()
    
    var body: some View {
        ZStack {
            Color(.clear)
                .ignoresSafeArea()
            
            ZStack {
                // Background ring (gray)
                RingView(trimStart: 0.125, trimEnd: 0.875, opacity: 0.3, color: .gray)
                    .rotationEffect(Angle(degrees: 90))  // Start from the left
                
                // Foreground ring (green) showing progress
                RingView(trimStart: 0.125, trimEnd: CGFloat(healthKitManager.goalPercentage * 0.7292), opacity: 1.0, color: .green)
                    .rotationEffect(Angle(degrees: 90))  // Start from the left
                
//                // Marker pointer
//                MarkerView(goalPercentage: healthKitManager.goalPercentage)
//                    .rotationEffect(Angle(degrees: 290))  // Start from the left
            }
            
            // Display the step data overlay
            DisplayStepDataView()
        }
        .onAppear {
            Task {
//                await healthKitManager.fetchMetrics(for: Date.now)  // Fetch steps when view appears
                await healthKitManager.startTrackingMetrics(for: Date.now)
            }
        }
        .onChange(of: healthKitManager.totalSteps) {
            try? context.save()
        }
    }
}

//#Preview {
//    ProgressCircle()
//        .environmentObject(HealthKitManager())
//}

struct MarkerView: View {
    var goalPercentage: CGFloat
    var markerSize: CGFloat = 10.0 // Size of the marker

    var body: some View {
        GeometryReader { geometry in
            let angle = (goalPercentage * 180) - 90 // Convert percentage to angle
            let radius = (geometry.size.width / 2) - (markerSize / 2) // Position the marker outside the circle
            
            // Calculate the x and y position of the marker
            let x = radius * cos(Angle(degrees: angle).radians)
            let y = radius * sin(Angle(degrees: angle).radians)
            
            Rectangle() // Use a square (rectangle) for the marker
                .fill(Color.red)
                .frame(width: markerSize, height: markerSize)
                .position(x: geometry.size.width / 2 + x, y: geometry.size.height / 2 + y)
        }
        .frame(width: 300, height: 300) // Match the size of the progress view
    }
}
