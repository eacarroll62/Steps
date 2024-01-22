//
//  Distance.swift
//  Steps
//
//  Created by Eric Carroll on 12/19/23.
//

import Foundation

struct Distance: Identifiable, Hashable, Comparable {
    typealias miles = Double
    
    let id = UUID()
    let date: Date
    let count: miles
    
    static func < (lhs: Distance, rhs: Distance) -> Bool {
        lhs.date < rhs.date
    }
    
    static func == (lhs: Distance, rhs: Distance) -> Bool {
        lhs.date == rhs.date
    }
}
