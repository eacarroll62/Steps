//
//  TestView.swift
//  Steps
//
//  Created by Eric Carroll on 9/9/23.
//

import SwiftUI

struct ProgressCircle: View {
    @State var viewModel: HealthDataViewModel
    
    var body: some View {
        let trimStart: CGFloat = 0
        let trimEnd: CGFloat = viewModel.healthData.goalPercentage
//        let trimEnd: CGFloat = min(CGFloat(viewModel.healthData.goalPercentage), 1.0) * 0.875
        
        ZStack {
            Color(.clear)
                .ignoresSafeArea()
            ZStack {
                RingView()
                RingView(trimStart: trimStart, trimEnd: trimEnd, opacity: 1.0, color: .green)
//                    .animation(.linear, value: viewModel.healthData.goalPercentage)
            }
            .rotationEffect(Angle(degrees: 90))
            .overlay {
                DisplayStepDataView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ProgressCircle(viewModel: HealthDataViewModel())
}
