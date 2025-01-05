//
//  DataItem.swift
//  Steps
//
//  Created by Eric Carroll on 1/5/25.
//

import SwiftUI

struct DataItem: Identifiable {
    let id = UUID()
    let imageName: String
    let imageColor: Color
    var value: String
    let unit: String
    let accessibilityHint: String?
}
