//
//  RingView.swift
//  Steps
//
//  Created by Eric Carroll on 1/21/24.
//

import SwiftUI

struct RingView: View {
    var width: CGFloat = 300.0
    var height: CGFloat = 300.0
    var dashLength: CGFloat = 4.0
    var dashSpace: CGFloat = 4.5
    var lineWidth: CGFloat = 20.0
    var trimStart: CGFloat = 0
    var trimEnd: CGFloat = 1.0
    var opacity: CGFloat = 0.3
    var color: Color = .gray
    
    var body: some View {
        Circle()
            .trim(from: trimStart, to: trimEnd)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, dash: [dashLength, dashSpace]))
            .frame(width: width, height: height)
            .opacity(opacity)
            .foregroundColor(color)
    }
}

#Preview {
    RingView(width: 300.0, height: 300.0, dashLength: 4.0, dashSpace: 4.5, lineWidth: 20.0, trimStart: 0, trimEnd: 1.0, opacity: 0.3, color: .gray)
}
