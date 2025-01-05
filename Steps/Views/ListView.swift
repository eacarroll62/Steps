//
//  ListView.swift
//  Steps
//
//  Created by Eric Carroll on 11/15/23.
//

import SwiftUI

struct ListView: View {
    @StateObject var healthKitManager: HealthKitManager
    
//    let mockData: [HealthData] = [
//        HealthData(date: Date.from(2023, 09, 24, 7), count: 180.00),
//        HealthData(date: Date.from(2023, 09, 24, 9), count: 937.00),
//        HealthData(date: Date.from(2023, 09, 24, 11), count: 627.00),
//        HealthData(date: Date.from(2023, 09, 24, 14), count: 1679.00),
//        HealthData(date: Date.from(2023, 09, 24, 17), count: 2735.00),
//        HealthData(date: Date.from(2023, 09, 24, 20), count: 1787.00)
//    ]
    
    var body: some View {
        ZStack {
            Color(.clear).ignoresSafeArea(.all)
//            List {
//                ForEach(mockData) { daily in
//                    ForEach(healthKitManager.hourlySteps.keys.sorted(), id: \.self) { daily in
//                    HStack {
//                        Text("Hour/Steps: \(Calendar.current.component(.hour, from: daily.date))")
//                        Text("\(Int(daily.count))")
//                    }
//                }
//            }
//            .refreshable {
//                do {
//                    try await healthKitManager.totalSteps
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
        }
        .onAppear {
            Task {
                await healthKitManager.requestAuthorization()
                await healthKitManager.startTrackingMetrics(for: Date.now)
            }
        }
    }
}

//#Preview {
//    ListView()
//}
