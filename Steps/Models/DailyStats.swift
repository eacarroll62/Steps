//
//  Metrics.swift
//  Steps
//
//  Created by Eric Carroll on 11/18/24.
//

import Foundation
import SwiftData

@Model
class DailyStats {
    @Attribute(.unique) var date: Date
    var steps: Int
    var distance: Double
    var calories: Double
    var activeTime: Double
    var walkingSpeed: Double
    var walkingStepLength: Double
    var stepGoal: Int
    
    init(
        date: Date,
        steps: Int = 0,
        distance: Double = 0,
        calories: Double = 0,
        activeTime: Double = 0,
        walkingSpeed: Double = 0,
        walkingStepLength: Double = 0,
        stepGoal: Int = 0
    ) {
        self.date = date
        self.steps = steps
        self.distance = distance
        self.calories = calories
        self.activeTime = activeTime
        self.walkingSpeed = walkingSpeed
        self.walkingStepLength = walkingStepLength
        self.stepGoal = stepGoal
    }
    
    static var mockMetrics: [DailyStats] {
        [
            DailyStats(date: Date.from(2023, 09, 23, 24), steps: 180, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 1), steps: 180, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 2), steps: 190, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 3), steps: 200, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 4), steps: 210, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 5), steps: 220, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 6), steps: 230, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 7), steps: 180, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 8), steps: 240, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 9), steps: 937, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 10), steps: 1005, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 11), steps: 627, distance: 1000.00, calories: 10000, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 12), steps: 739, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 13), steps: 836, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 14), steps: 1679, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 15), steps: 912, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 16), steps: 780, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 17), steps: 2735, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 18), steps: 680, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 19), steps: 1180, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 20), steps: 1787, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 21), steps: 180, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 22), steps: 180, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            DailyStats(date: Date.from(2023, 09, 24, 23), steps: 180, distance: 1000.00, calories: 1000.00, activeTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000)
        ]
    }
    
}
