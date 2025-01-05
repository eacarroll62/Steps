//
//  StepsWidget.swift
//  StepsWidget
//
//  Created by Eric Carroll on 11/18/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> StepsWidgetEntry {
        StepsWidgetEntry(date: Date(), goalSteps: 10000, totalSteps: 0, goalPercentage: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (StepsWidgetEntry) -> ()) {
        let entry = loadStepData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [StepsWidgetEntry] = []
    
        // Get data from shared storage
        let sharedDefaults = UserDefaults(suiteName: "group.com.UsefulApps.Steps")
        
        let goalSteps = sharedDefaults?.integer(forKey: "goalSteps") ?? -1
        let totalSteps = sharedDefaults?.integer(forKey: "totalSteps") ?? -1
        let goalPercentage = goalSteps == 0 ? 0 : Double(totalSteps) / Double(goalSteps)
        
        // Create timeline entries
        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = StepsWidgetEntry(date: entryDate, goalSteps: goalSteps, totalSteps: totalSteps, goalPercentage: goalPercentage)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    // Helper method to load data from UserDefaults
    private func loadStepData() -> StepsWidgetEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.com.UsefulApps.Steps")
        let goalSteps = sharedDefaults?.integer(forKey: "goalSteps") ?? 0
        let totalSteps = sharedDefaults?.integer(forKey: "totalSteps") ?? 0
        
        return StepsWidgetEntry(date: Date(), goalSteps: goalSteps, totalSteps: totalSteps, goalPercentage: Double(totalSteps)/Double(goalSteps))
    }
}

struct StepsWidgetEntry: TimelineEntry {
    let date: Date
    let goalSteps: Int
    let totalSteps: Int
    let goalPercentage: Double
}

struct StepsWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(Color.lightSeaGreen)
            ProgressView(
                value: entry.goalPercentage,
                label: { Text("Step Progress").font(.system(size: 12)).bold() },
                currentValueLabel: { Text("\(entry.totalSteps) out of \(entry.goalSteps)").bold() }
            )
            .padding()
            .progressViewStyle(LinearProgressViewStyle())
            .tint(Color.hunterGreen)
        }
    }
}

struct StepsWidget: Widget {
    let kind: String = "StepsWidget"
    @Environment(\.modelContext) var modelContext
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StepsWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("My Steps Widget")
        .description("This is the widget for the Steps App.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    StepsWidget()
} timeline: {
    StepsWidgetEntry(date: .now, goalSteps: 12000, totalSteps: 8420, goalPercentage: 8420/12000)
}
