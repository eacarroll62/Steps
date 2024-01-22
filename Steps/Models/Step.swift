//
//  Step.swift
//  Steps
//
//  Created by Eric Carroll on 12/18/23.
//

import Foundation

struct Step: Identifiable, Hashable, Comparable {
    typealias steps = Double
    
    let id = UUID()
    let date: Date
    let count: steps
    
    static func < (lhs: Step, rhs: Step) -> Bool {
        lhs.date < rhs.date
    }
    
    static func == (lhs: Step, rhs: Step) -> Bool {
        lhs.date == rhs.date
    }
}
