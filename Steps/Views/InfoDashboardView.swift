//
//  InfoDashboardView.swift
//  Steps
//
//  Created by Eric Carroll on 8/20/23.
//

import SwiftUI

struct InfoDashboardView: View {
    @State var viewModel: HealthDataViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                DataItemView(dataItem: DataItem(imageName: "flame.fill", imageColor: Color.red, value: viewModel.healthData.activeEnergyBurned.formattedString(1), unit: "kcal")).padding()

                DataItemView(dataItem: DataItem(imageName: "figure.walk", imageColor: Color.blue, value: viewModel.healthData.distanceWalkingRunning.formattedString(2), unit: "miles")).padding()

                DataItemView(dataItem: DataItem(imageName: "stopwatch.fill", imageColor: Color.green, value: viewModel.healthData.appleMoveTime.formattedString(2), unit: "minutes")).padding(5)

                DataItemView(dataItem: DataItem(imageName: "ruler", imageColor: Color.purple, value: viewModel.healthData.walkingStepLength.formattedString(1), unit: "inches")).padding(5)
                
                DataItemView(dataItem: DataItem(imageName: "speedometer", imageColor: Color.crimson, value: viewModel.healthData.walkingSpeed.formattedString(2), unit: "mph")).padding()
            }
        }
    }
}

#Preview {
    InfoDashboardView(viewModel: HealthDataViewModel())
}
