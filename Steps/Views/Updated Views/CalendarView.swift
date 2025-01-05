//
//  CalendarView.swift
//  Steps
//
//  Created by Eric Carroll on 12/1/24.
//

import SwiftUI
import SwiftData

//struct CalendarView: View {
//    @EnvironmentObject var dataManager: DataManager
//    @Binding var selectedDate: Date?
//    @Binding var showCalendar: Bool
//    
//    private let calendar = Calendar.current
//    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
//    
//    var body: some View {
//        VStack {
//            CalendarHeader()
//            DayLabels()
//            CalendarGrid()
//            Spacer()
//        }
//        .padding()
//        .background(Color.black.ignoresSafeArea())
//    }
//    
//    // MARK: - Header
//    @ViewBuilder
//    private func CalendarHeader() -> some View {
//        HStack {
//            Button(action: {
//                withAnimation { showCalendar = false }
//            }) {
//                Image(systemName: "xmark.circle.fill")
//                    .font(.title2)
//                    .foregroundColor(.white)
//            }
//            
//            Spacer()
//            
//            Text(calendarMonthYearString(for: selectedDate ?? Date()))
//                .font(.headline)
//                .foregroundColor(.white)
//            
//            Spacer()
//            
//            Button(action: {
//                selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate ?? Date())
//            }) {
//                Image(systemName: "chevron.left")
//                    .foregroundColor(.white)
//            }
//            
//            Button(action: {
//                selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate ?? Date())
//            }) {
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.white)
//            }
//        }
//        .padding()
//    }
//    
//    // MARK: - Day Labels
//    @ViewBuilder
//    private func DayLabels() -> some View {
//        LazyVGrid(columns: columns, spacing: 10) {
//            ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
//                Text(day)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//    
//    // MARK: - Calendar Grid
//    @ViewBuilder
//    private func CalendarGrid() -> some View {
//        LazyVGrid(columns: columns, spacing: 10) {
//            // Placeholder for the starting weekday
//            ForEach(0..<startingWeekday(for: selectedDate ?? Date()), id: \.self) { _ in
//                Spacer()
//            }
//            
//            // Actual days of the month
//            ForEach(daysInMonth(for: selectedDate ?? Date()), id: \.self) { date in
//                let steps = dataManager.fetchDailyStats(for: date)?.steps ?? 0
//                let goalAchieved = steps >= (dataManager.fetchDailyStats(for: date)?.stepGoal ?? 0)
//                
//                VStack {
//                    Text("\(calendar.component(.day, from: date))")
//                        .font(.caption)
//                        .foregroundColor(goalAchieved ? .white : .gray)
//                        .frame(maxWidth: .infinity)
//                        .background(goalAchieved ? Color.blue.clipShape(Circle()) as! Color : Color.clear)
//                        .onTapGesture {
//                            selectedDate = date
//                            showCalendar = false
//                        }
//                }
//            }
//        }
//        .padding()
//    }
//    
//    // MARK: - Helper Functions
//    private func calendarMonthYearString(for date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM yyyy"
//        return formatter.string(from: date)
//    }
//    
//    private func daysInMonth(for date: Date) -> [Date] {
//        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }
//        var dates = [Date]()
//        var currentDate = monthInterval.start
//        while currentDate < monthInterval.end {
//            dates.append(currentDate)
//            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
//        }
//        return dates
//    }
//    
//    private func startingWeekday(for date: Date) -> Int {
//        guard let firstDay = calendar.dateInterval(of: .month, for: date)?.start else { return 0 }
//        return calendar.component(.weekday, from: firstDay) - 1 // Sunday = 0
//    }
//}

struct CalendarView: View {
    @ObservedObject var healthKitManager: HealthKitManager
    @Binding var selectedDate: Date?
    @Binding var showCalendar: Bool
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        showCalendar = false
                    }
                }) {}
                    .padding()
            }
            
            DatePicker(
                "",
                selection: Binding(
                    get: { selectedDate ?? Date() },
                    set: { newDate in
                        selectedDate = newDate
                        withAnimation {
                            showCalendar = false
                        }
                    }
                ),
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .labelsHidden()
            .colorScheme(.dark)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}

//#Preview {
//    @Previewable @State var previewDate: Date? = nil
//    let mockContainer = try? ModelContainer(for: DailyStats.self)
//    let mockContext = mockContainer?.mainContext ?? ModelContext(ModelContainer())
//    
//    // Mock DataManager
//    let mockDataManager = DataManager(modelContext: ModelContext(mockContainer ?? ModelContainer()))
//
//    CalendarView(
//        healthKitManager: HealthKitManager(dataManager: mockDataManager),
//        selectedDate: $previewDate,
//        showCalendar: .constant(false)
//    )
//}
