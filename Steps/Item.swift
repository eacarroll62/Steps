//
//  Item.swift
//  Steps
//
//  Created by Eric Carroll on 8/20/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
