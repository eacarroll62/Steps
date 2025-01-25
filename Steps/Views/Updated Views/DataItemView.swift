//
//  DataItemView.swift
//  Steps
//
//  Created by Eric Carroll on 11/27/24.
//

import SwiftUI

struct DataItemView: View {
    let dataItem: DataItem
    var body: some View {
        VStack {
            Image(systemName: dataItem.imageName)
                .fixedSize()
                .frame(width: 36, height: 10)
                .foregroundColor(dataItem.imageColor)
                .font(.system(size: 16))
                .shadow(color: dataItem.imageColor.opacity(0.5), radius: 10, x: 4, y: 24)
                
            
            Text(dataItem.value)
                .font(.system(size: 16, design: .monospaced))
                .fixedSize()
                .frame(width: 36)
                .padding(.top, 10)
            
            Text(dataItem.unit)
                .font(.system(size: 16))
        }
        .foregroundColor(.whiteSmoke)
    }
}

#Preview {
    HStack {
        DataItemView(dataItem: DataItem(imageName: "flame.fill", imageColor: Color.red, value: "500", unit: "kcal", accessibilityHint: "Calories"))
        DataItemView(dataItem: DataItem(imageName: "figure.walk", imageColor: Color.blue, value: "5.2", unit: "miles", accessibilityHint: "Distance Walked"))
        DataItemView(dataItem: DataItem(imageName: "stopwatch.fill", imageColor: Color.green, value: "210", unit: "mins", accessibilityHint: "Activity Time"))
        DataItemView(dataItem: DataItem(imageName: "ruler", imageColor: Color.purple, value: "19.2", unit: "inches", accessibilityHint: "Step Length"))
        DataItemView(dataItem: DataItem(imageName: "speedometer", imageColor: Color.crimson, value: "2.3", unit: "mph", accessibilityHint: "Walking Speed"))
        DataItemView(dataItem: DataItem(imageName: "figure.stairs",
            imageColor: .orange, value: "3", unit: "flights",
            accessibilityHint: "Flights Climbed"))
    }
}


