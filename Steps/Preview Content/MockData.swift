//
//  MockData.swift
//  Steps
//
//  Created by Eric Carroll on 11/18/24.
//

import SwiftUI
import SwiftData

struct MockData: PreviewModifier {
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: DailyStats.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        // Insert objects here
        DailyStats.mockMetrics.forEach { metric in
            container.mainContext.insert(metric)
        }
        
        return container
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static var mockData: Self = .modifier(MockData())
}

