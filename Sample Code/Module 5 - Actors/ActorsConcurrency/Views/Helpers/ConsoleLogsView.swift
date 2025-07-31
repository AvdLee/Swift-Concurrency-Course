//
//  ConsoleLogsView.swift
//  ActorsConcurrency
//
//  Created by A.J. van der Lee on 31/07/2025.
//


import SwiftUI

struct ConsoleLogsView: View {
    
    let logs: [String]
    
    var body: some View {
        if logs.isEmpty {
            Text("No logs yet")
                .font(.system(.body, design: .monospaced))
        } else {
            ForEach(Array(logs.enumerated()), id: \.offset) { index, log in
                Text(log)
                    .font(.system(.body, design: .monospaced))
            }
        }
    }
}