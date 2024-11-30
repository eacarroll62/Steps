//
//  InfoDashboardView.swift
//  Steps
//
//  Created by Eric Carroll on 8/20/23.
//

import SwiftUI

struct InfoDashboardView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                DataItemView(dataItem: DataItem(imageName: "flame.fill", imageColor: Color.red, value: healthKitManager.totalCalories.formattedString(2), unit: "kcal")).padding()

                DataItemView(dataItem: DataItem(imageName: "figure.walk", imageColor: Color.blue, value: healthKitManager.totalDistance.formattedString(2), unit: "miles")).padding()

                DataItemView(dataItem: DataItem(imageName: "stopwatch.fill", imageColor: Color.green, value: healthKitManager.totalMoveTime.formattedString(2), unit: "mins")).padding(5)

                DataItemView(dataItem: DataItem(imageName: "ruler", imageColor: Color.purple, value: healthKitManager.averageWalkingStepLength.formattedString(1), unit: "inches")).padding(5)
                
                DataItemView(dataItem: DataItem(imageName: "speedometer", imageColor: Color.crimson, value: healthKitManager.averageWalkingSpeed.formattedString(2), unit: "mph")).padding()
            }
        }
        .onAppear {
            Task {
                await healthKitManager.fetchMetrics()  // Trigger your data fetching here
//                healthKitManager.startTrackingMotion()
            }
            
            healthKitManager.startTrackingMotion()
        }
    }
}

#Preview {
    InfoDashboardView()
        .environmentObject(HealthKitManager())
}
