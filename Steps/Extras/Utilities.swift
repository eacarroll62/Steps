//
//  Enums, Constants, Extenstions.swift
//  Steps
//
//  Created by Eric Carroll on 8/20/23.
//

import SwiftUI

extension Date {
    static var startOfDay: Date {
        return Calendar.current.startOfDay(for: Date())
    }
}

extension Date {
    static func from(_ year: Int, _ month: Int, _ day: Int, _ hour: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = DateComponents(calendar: calendar, year: year, month: month, day: day, hour: hour)
        return calendar.date(from: dateComponents)!
    }
}

extension Double {
    func formattedString(_ maxDigits: Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = maxDigits
        numberFormatter.maximumFractionDigits = maxDigits
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

extension Int {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

extension Int: @retroactive VectorArithmetic {
    mutating public func scale(by rhs: Double) {
        self = Int(Double(self) * rhs)
    }

    public var magnitudeSquared: Double {
        Double(self * self)
    }
}

enum DisplayType: Int, Identifiable, CaseIterable {
    case list
    case chart
    
    var id: Int {
        rawValue
    }
}

extension DisplayType {
    var icon: String {
        switch self {
            case .list:
                return "list.bullet"
            case .chart:
                return "chart.bar"
        }
    }
}
