//
//  HealthStatsModel.swift
//  Steps
//
//  Created by Eric Carroll on 12/14/23.
//

import Foundation

struct HealthDataModel {
    var stepCount: Int = 0
    var distanceWalkingRunning: Double = 0
    var activeEnergyBurned: Double = 0
    var appleMoveTime: Double = 0
    var walkingSpeed: Double = 0
    var walkingStepLength: Double = 0
    var stepGoal: Int = 10000
    var allStepData: [Step] = []
    var allDistanceData: [Distance] = []
    var start: Bool = false
    
    var goalPercentage: Double {
        (Double(stepCount) / Double(stepGoal))
    }
    
    var calculatedTime: Double {
        if walkingSpeed > 0 {
            return (distanceWalkingRunning / walkingSpeed) * 60
        } else {
            return 0.00
        }
    }
}
