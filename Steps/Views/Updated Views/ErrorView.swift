//
//  ErrorView.swift
//  Steps
//
//  Created by Eric Carroll on 1/12/25.
//

import SwiftUI

struct ErrorView: View {
    let error: Error

    var body: some View {
        VStack {
            Text("An error occurred")
                .font(.title)
                .padding()
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .padding()
            Button("Retry") {
                // Add retry logic here if applicable
            }
            .padding()
        }
    }
}

//#Preview {
//    ErrorView(error: )
//}
