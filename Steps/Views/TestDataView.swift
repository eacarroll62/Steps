//
//  TestDataView.swift
//  Steps
//
//  Created by Eric Carroll on 12/1/24.
//

import SwiftUI
import SwiftData

struct TestDataView: View {
    @Environment(\.dataManager) var dataManager
    
    @State private var date = Date()
    @State private var steps = 0
    @State private var fetchedStats: DailyStats?

    var body: some View {
        VStack(spacing: 20) {
            Text("SwiftData Test View")
                .font(.headline)
            
            // Input for creating test data
            VStack {
                DatePicker("Select Date", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                Stepper("Steps: \(steps)", value: $steps, in: 0...100000, step: 1000)
                Button("Save Data") {
                    saveTestData()
                }
                .buttonStyle(.borderedProminent)
            }
            
            Divider()
            
            // Fetch and display data
            Button("Fetch Data for Selected Date") {
                fetchTestData()
            }
            .buttonStyle(.bordered)
            
            if let stats = fetchedStats {
                VStack {
                    Text("Data for \(formattedDate(stats.date))")
                    Text("Steps: \(stats.steps)")
                    Text("Distance: \(stats.distance, specifier: "%.2f") km")
                    Text("Calories: \(stats.calories, specifier: "%.2f") kcal")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            } else {
                Text("No data available for selected date")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
    
    // Helper function to save test data
    private func saveTestData() {
        dataManager?.saveDailyStats(
            steps: steps,
            distance: Double(steps) / 1300,  // Example conversion to km
            calories: Double(steps) * 0.05, // Example calorie burn
            walkingSpeed: 5.0,              // Example speed
            walkingStepLength: 0.75,        // Example step length in meters
            activeTime: Double(steps) / 100, // Example active time in minutes
            stepGoal: 10000
        )
    }
    
    // Helper function to fetch data for the selected date
    private func fetchTestData() {
        fetchedStats = dataManager?.fetchDailyStats(for: date)
    }
    
    // Helper function to format dates
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    TestDataView()
}
