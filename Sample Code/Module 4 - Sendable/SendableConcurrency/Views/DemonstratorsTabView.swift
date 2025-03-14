//
//  DemonstratorsTabView.swift
//  SendableConcurrency
//
//  Created by A.J. van der Lee on 14/03/2025.
//


import SwiftUI

struct DemonstratorsTabView: View {
    let dataRaceDemonstrator = DataRaceDemonstrator()

    var body: some View {
        Form {
            Section(header: Text("Tap the button and look below for the print statements to learn")) {
                Button("Demonstrate Data Race") {
                    dataRaceDemonstrator.demonstrateDataRace()
                }
                Button("Demonstrate Data Race GCD Fix") {
                    dataRaceDemonstrator.demonstrateSynchronizedGCDDataRaceFix()
                }
                Button("Demonstrate Data Race Swift Concurrency Fix") {
                    Task {
                        await dataRaceDemonstrator.demonstrateConcurrencyActorDataRaceFix()
                    }
                }
                Button("Demonstrate Race Condition") {
                    Task {
                        await dataRaceDemonstrator.demonstrateRaceCondition()
                    }
                }
            }
        }
    }
}
