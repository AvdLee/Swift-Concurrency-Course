//
//  ContentView.swift
//  MemoryManagementConcurrency
//
//  Created by A.J. van der Lee on 25/04/2025.
//

import SwiftUI


struct ContentView: View {
    
    private let retainDemonstrator = RetainDemonstrator()
    private let retainCycleDemonstrator = RetainCycleDemonstrator()
    
    var body: some View {
        Form {
            Button("Demonstrate Strong Retain") {
                retainDemonstrator.demonstrateStrongSelf()
            }
            Button("Demonstrate Weak Retain") {
                retainDemonstrator.demonstrateWeakSelf()
            }
            Button("Demonstrate Strong Retain Cycle") {
                retainCycleDemonstrator.demonstrateRetainCycle()
            }
            Button("Demonstrate Weak Retain Cycle") {
                retainCycleDemonstrator.demonstrateNoRetainCycle()
            }
            Button("Demonstrate Async Sequence Strong Retain Cycle") {
                retainCycleDemonstrator.demonstrateAsyncSequenceRetainCycle()
            }
            Button("Demonstrate Async Sequence Weak Retain Cycle") {
                retainCycleDemonstrator.demonstrateAsyncSequenceNoRetainCycle()
            }
        }
    }
}

#Preview {
    ContentView()
}
