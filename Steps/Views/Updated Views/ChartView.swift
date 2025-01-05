//
//  ChartView.swift
//  Steps
//
//  Created by Eric Carroll on 9/8/23.
//

import SwiftUI
import Charts

struct ChartView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    
    private var maxDataValue: Int {
        healthKitManager.stepCount.values.max() ?? 0
    }
    
    private var hourFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"  // 24-hour time format
        return formatter
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
    
    var body: some View {
        ZStack {
            Color(.clear).ignoresSafeArea(.all)
            
            Chart(healthKitManager.hourlyStepCounts.keys.sorted(), id: \.self) { hour in
                // Convert the hour string to a Date (just the hour part)
                if let hourInt = Int(hour) {
                    // Create a date using the hour (e.g., "14" => "2024-01-01 14:00")
                    let calendar = Calendar.current
                    let now = Date()
                    let date = calendar.date(bySettingHour: hourInt, minute: 0, second: 0, of: now)!
                    
                    // BarMark for each hour
                    BarMark(
                        x: .value("Hour", date, unit: .hour),
                        y: .value("Steps", healthKitManager.stepCount[hour] ?? 0),
                        width: 10
                    )
                    .foregroundStyle(Color.green)
                    .cornerRadius(4)
                }
            }
            .chartYScale(domain: 0...(maxDataValue + 500))
            .frame(height: 150)  // Set chart height
            .padding([.leading, .trailing], 20)
            .cornerRadius(12)        // Optional: rounded corners for chart
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 1)) { value in
                    if let date = value.as(Date.self) {
                        let hour = Calendar.current.component(.hour, from: date)
                        
                        // Show labels only for every third hour
                        if hour % 3 == 0 {
                            AxisValueLabel {
                                // Display only the hour as a string (e.g., "00", "03", "06", ...)
                                Text("\(hour < 10 ? "0" : "")\(hour)") // Format hour with leading zero if necessary
//                                    .rotationEffect(.degrees(90)) // Rotate label for better fit
                                    .padding(.top, 10) // Optional: Add padding for better spacing
                            }
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .onAppear {
            Task {
                await healthKitManager.startTrackingMetrics(for: Date.now)  // Trigger data fetching here
            }
        }
    }
}

//#Preview {
//    ChartView()
//        .environmentObject(HealthKitManager())
//}
