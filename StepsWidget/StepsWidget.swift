//
//  StepsWidget.swift
//  StepsWidget
//
//  Created by Eric Carroll on 11/18/24.
//

import WidgetKit
import SwiftUI
import HealthKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct StepsWidgetEntryView : View {
    @StateObject var healthKitManager = HealthKitManager()
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
//            Text("Time:")
//            Text(entry.date, style: .time)
            Text("Goal: \(healthKitManager.goalSteps)")
            Text("Total Steps: \(healthKitManager.totalSteps)")
            Text("\((100.0 * healthKitManager.goalPercentage).formattedString(2))% Completed!")
//            ProgressCircle()
        }
        .onAppear {
            Task {
                await healthKitManager.fetchMetrics()  // Fetch steps when view appears
            }
        }
    }
        
}

struct StepsWidget: Widget {
    let kind: String = "StepsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            if #available(iOS 17.0, *) {
            StepsWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
//            } else {
//                StepsWidgetEntryView(entry: entry)
//                    .padding()
//                    .background()
//            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    StepsWidget()
} timeline: {
    SimpleEntry(date: .now)
}
