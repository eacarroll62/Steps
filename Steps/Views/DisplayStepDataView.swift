//
//  DisplayStepDataView.swift
//  Steps
//
//  Created by Eric Carroll on 1/21/24.
//

import SwiftUI

struct DisplayStepDataView: View {
    @State var viewModel: HealthDataViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Goal: \(viewModel.healthData.stepGoal)")
            withAnimation {
                Text("\(viewModel.healthData.stepCount)")
                    .contentTransition(.numericText())
                .font(.system(size: 50))
            }
//                    .animation (
//                        .easeInOut(duration: 20),
//                        value: viewModel.healthData.stepCount.formattedString()
//                    )
            Text("\((100.0 * viewModel.healthData.goalPercentage).formattedString(2))% Completed!")
        }
        .bold()
        .offset(y: -20)
        .font(.system(size: 20))
        .foregroundColor(.gray)
    }
}

#Preview {
    DisplayStepDataView(viewModel: HealthDataViewModel())
}
