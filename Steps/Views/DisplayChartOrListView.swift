//
//  DisplayChartOrListView.swift
//  Steps
//
//  Created by Eric Carroll on 1/21/24.
//

import SwiftUI

struct DisplayChartOrListView: View {
    @Environment(HealthDataViewModel.self) var viewModel
    @State private var displayType: DisplayType = .chart
    
    var body: some View {
        Group {
            switch displayType {
                case .list:
                    ListView(viewModel: viewModel)
                case .chart:
                    ChartView(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        Picker("Selection", selection: $displayType) {
            ForEach(DisplayType.allCases) { displayType in
                Image(systemName: displayType.icon).tag(displayType)
            }
        }
        .pickerStyle(.segmented)
        .background(Color.green)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
}

#Preview {
    DisplayChartOrListView()
        .environment(HealthDataViewModel())
}
