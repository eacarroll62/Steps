//
//  DisplayStepDataView.swift
//  Steps
//
//  Created by Eric Carroll on 1/21/24.
//
//
import SwiftUI
//
//struct DisplayStepDataView: View {
//    @EnvironmentObject var healthKitManager: HealthKitManager
//    @State private var showCalendar: Bool = false
//    @State private var selectedDate: Date? = nil
//    
//    var body: some View {
//        VStack(spacing: 40) {
//            VStack {
//                HStack {
//                    Text(Date(), format: .dateTime.month(.abbreviated).day().year())
//                        .font(.caption)
//                    Button(action: {
//                        withAnimation {
//                            showCalendar.toggle()
//                        }
//                    }) {
//                        Image(systemName: "calendar")
//                            .font(.title2)
//                            .foregroundColor(.blue)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//            }
//            
//            VStack {
//                Text("\(healthKitManager.totalSteps.formatted(.number.grouping(.never)))")
//                    .monospaced()
//                    .font(.system(size: 50))
//                    .bold()
//                    .contentTransition(.numericText())
//            }
//            
//            VStack {
//                Text("Step Goal: \(healthKitManager.goalSteps)")
//                    .font(.caption)
//                    .bold()
//                
//                Text("\((100.0 * healthKitManager.goalPercentage).formattedString(2))% Completed")
//                    .font(.caption2)
//            }
//            
//            if showCalendar {
//                CalendarView(
//                    healthKitManager: healthKitManager,
//                    selectedDate: $selectedDate,
//                    showCalendar: $showCalendar
//                )
//                .transition(.slide) // Smooth transition
//            }
//            
////            if let selectedDate = selectedDate {
////                NavigationLink(destination: MainView().environmentObject(healthKitManager)) {
////                    Text("Go to Detailed View for \(selectedDate, format: .dateTime.month().day().year())")
////                        .font(.caption)
////                        .padding()
////                        .background(Color.blue)
////                        .foregroundColor(.white)
////                        .cornerRadius(8)
////                }
////            }
//        }
//        .monospaced()
////        .bold()
//        .foregroundColor(.gray)
////        .frame(width: 200, height:200)
//        .onAppear {
//            Task {
//                await healthKitManager.fetchMetrics()  // Fetch steps when view appears
//            }
//        }
//    }
//}

struct DisplayStepDataView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State private var showCalendar: Bool = false
    @State private var selectedDate: Date? = nil
    @State private var animatedSteps: Int = 0 // For the animated step count

    var body: some View {
        VStack(spacing: 40) {
            VStack {
                HStack {
                    Text(Date(), format: .dateTime.month(.abbreviated).day().year())
                        .font(.caption)
                    Image(systemName: "calendar")
                       .font(.title)
                       .foregroundColor(.green)
                       .onTapGesture {
                           withAnimation {
                               showCalendar = true
                           }
                       }
                }
            }

            VStack {
                Text("\(healthKitManager.totalSteps.formatted(.number.grouping(.never)))")
                    .monospaced()
                    .font(.system(size: 50))
                    .bold()
                    .animation(nil, value: animatedSteps)
           //         .contentTransition(.numericText())
            }

            VStack {
                Text("Step Goal: \(healthKitManager.goalSteps)")
                    .font(.caption)
                    .bold()

                Text("\((100.0 * healthKitManager.goalPercentage).formattedString(2))% Completed")
                    .font(.caption2)
            }
        }
        .monospaced()
        .foregroundColor(.gray)
        .frame(width: 200, height: 200)
        .sheet(isPresented: $showCalendar) {
            CalendarView(
                healthKitManager: healthKitManager, selectedDate: $selectedDate,
                showCalendar: $showCalendar
            )
            .presentationDetents([.fraction(0.70), .large]) // Example detents
            .presentationDragIndicator(.visible) // Optional: Show drag indicator
        }
        .onAppear {
            startAnimatingSteps(from: animatedSteps, to: healthKitManager.totalSteps)
        }
        .onChange(of: healthKitManager.totalSteps) { _, newValue in
            startAnimatingSteps(from: animatedSteps, to: newValue)
        }
    }

    private func startAnimatingSteps(from currentSteps: Int, to targetSteps: Int) {
        guard targetSteps != currentSteps else { return } // No need to animate if values are the same

        let updateInterval: Double = 0.75 // Delay per step in seconds (adjust for visibility)

        Task {
            var steps = currentSteps
            while steps != targetSteps {
                steps += steps < targetSteps ? 1 : -1 // Increment or decrement by 1
                animatedSteps = steps // Update the displayed value

                // Allow time for UI to render each update
                try await Task.sleep(nanoseconds: UInt64(updateInterval * 1_000_000_000))
            }
        }
    }
}

//#Preview {
//    DisplayStepDataView()
//        .environmentObject(HealthKitManager())
//}

