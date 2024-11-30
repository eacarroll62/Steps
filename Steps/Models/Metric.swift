//
//  Metrics.swift
//  Steps
//
//  Created by Eric Carroll on 11/18/24.
//

import Foundation
import SwiftData

@Model
class Metric {
    var date: Date
    var steps: Int
    var distance: Double
    var calories: Double
    var appleMoveTime: Double
    var walkingSpeed: Double
    var walkingStepLength: Double
    var stepGoal: Int
    
    init(date: Date, steps: Int, distance: Double, calories: Double, appleMoveTime: Double, walkingSpeed: Double, walkingStepLength: Double, stepGoal: Int) {
        self.date = date
        self.steps = steps
        self.distance = distance
        self.calories = calories
        self.appleMoveTime = appleMoveTime
        self.walkingSpeed = walkingSpeed
        self.walkingStepLength = walkingStepLength
        self.stepGoal = stepGoal
    }
    
    static var mockMetrics: [Metric] {
        [
//            Metric(date: Date.now, steps: 12387, distance: 5.2, calories: 505, appleMoveTime: 123.4, walkingSpeed: 12.3, walkingStepLength: 12.3, stepGoal: 12387)
            Metric(date: Date.from(2023, 09, 23, 24), steps: 180, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 1), steps: 180, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 2), steps: 190, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 3), steps: 200, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 4), steps: 210, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 5), steps: 220, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 6), steps: 230, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 7), steps: 180, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 8), steps: 240, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 9), steps: 937, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 10), steps: 1005, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 11), steps: 627, distance: 1000.00, calories: 10000, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 12), steps: 739, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 13), steps: 836, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 14), steps: 1679, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 15), steps: 912, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 16), steps: 780, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 17), steps: 2735, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 18), steps: 680, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 19), steps: 1180, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 20), steps: 1787, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 21), steps: 180, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 22), steps: 180, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000),
            Metric(date: Date.from(2023, 09, 24, 23), steps: 180, distance: 1000.00, calories: 1000.00, appleMoveTime: 1000.00, walkingSpeed: 1000.00, walkingStepLength: 1000.00, stepGoal: 10000)
        ]
    }
    
}
