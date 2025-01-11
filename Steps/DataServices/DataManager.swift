//
//  DataManager.swift
//  Steps
//
//  Created by Eric Carroll on 11/30/24.
//

import SwiftData
import Foundation

@MainActor
class DataManager: ObservableObject {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveDailyStats(steps: Int, distance: Double, flights: Int, calories: Double, walkingSpeed: Double, walkingStepLength: Double, activeTime: Double, stepGoal: Int) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Check if stats for today already exist
        let fetchDescriptor = FetchDescriptor<DailyStats>(predicate: #Predicate { $0.date == today })
        
        let dailyStats: DailyStats
        
        if let existingStats = try? modelContext.fetch(fetchDescriptor).first {
            dailyStats = existingStats
        } else {
            dailyStats = DailyStats(date: today)
            modelContext.insert(dailyStats)
        }
        
        // Update stats
        dailyStats.steps = steps
        dailyStats.distance = distance
        dailyStats.calories = calories
        dailyStats.walkingSpeed = walkingSpeed
        dailyStats.walkingStepLength = walkingStepLength
        dailyStats.activeTime = activeTime
        dailyStats.stepGoal = stepGoal
        
        // Save context
        try? modelContext.save()
    }
    
    // Fetch daily stats for a specific date
    func fetchDailyStats(for date: Date) -> DailyStats? {
        let startOfDay = Calendar.current.startOfDay(for: date)  // Ensure it's the start of the day
        
        let fetchDescriptor = FetchDescriptor<DailyStats>(predicate: #Predicate { $0.date == startOfDay })
        
        return try? modelContext.fetch(fetchDescriptor).first
    }
    
    // Fetch all daily stats for a given date range
    func fetchDailyStats(forRange range: DateInterval) -> [DailyStats] {
        let fetchDescriptor = FetchDescriptor<DailyStats>(predicate: #Predicate { $0.date >= range.start && $0.date <= range.end })
        
        return (try? modelContext.fetch(fetchDescriptor)) ?? []
    }
    
    // Helper function to format date as a string for comparison
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    // Add more methods for fetching data as needed...
}
