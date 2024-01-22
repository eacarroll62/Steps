//
//  ChartView.swift
//  Steps
//
//  Created by Eric Carroll on 9/8/23.
//

import SwiftUI
import Charts


struct ChartView: View {
    @State var viewModel: HealthDataViewModel
    
    let mockData: [Step] = [Step(date: Date.from(2023, 09, 24, 7), count: 180.00), Step(date: Date.from(2023, 09, 24, 9), count: 937.00), Step(date: Date.from(2023, 09, 24, 11), count: 627.00), Step(date: Date.from(2023, 09, 24, 14), count: 1679.00), Step(date: Date.from(2023, 09, 24, 17), count: 2735.00), Step(date: Date.from(2023, 09, 24, 20), count: 1787.00)]
    
    var body: some View {
        ZStack {
            Color(.clear).ignoresSafeArea(.all)
//            Chart(mockData) { daily in
            Chart(viewModel.healthData.allStepData) { daily in
                PointMark(x: .value("Labels", daily.date, unit: .hour), y: .value( "Values", daily.count))
                    .symbol(.diamond)
                    .foregroundStyle(Color.green)
            }
            .chartXAxisLabel {
                Text("Hour")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.top)
            }
            .chartYAxisLabel(position: .leading, alignment: .center) {
                Text("Steps")
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            .dynamicTypeSize(.xSmall)
        }
    }
}

#Preview {
    ChartView(viewModel: HealthDataViewModel())
}
