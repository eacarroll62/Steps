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
            Color(.black)
                .ignoresSafeArea()
            ZStack {
                Ring()
                Ring(trimStart: trimStart, trimEnd: trimEnd, opacity: 1.0, color: .green)
//                    .animation(.linear, value: viewModel.healthData.goalPercentage)
            }
            .rotationEffect(Angle(degrees: 90))
            .overlay {
                Display(viewModel: viewModel)
            }
        }
    }
}

struct Ring: View {
    var width: CGFloat = 300.0
    var height: CGFloat = 300.0
    var dashLength: CGFloat = 4.0
    var dashSpace: CGFloat = 4.5
    var lineWidth: CGFloat = 20.0
    var trimStart: CGFloat = 0
    var trimEnd: CGFloat = 1.0
    var opacity: CGFloat = 0.3
    var color: Color = .white
    
    var body: some View {
        Circle()
            .trim(from: trimStart, to: trimEnd)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, dash: [dashLength, dashSpace]))
            .frame(width: width, height: height)
            .opacity(opacity)
            .foregroundColor(color)
    }
}

struct Display: View {
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
        .foregroundColor(.whiteSmoke)
    }
}

#Preview {
    ProgressCircle(viewModel: HealthDataViewModel())
}
