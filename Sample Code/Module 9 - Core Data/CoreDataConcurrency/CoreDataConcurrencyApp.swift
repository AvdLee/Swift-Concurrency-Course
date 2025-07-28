//
//  CoreDataConcurrencyApp.swift
//  CoreDataConcurrency
//
//  Created by A.J. van der Lee on 28/07/2025.
//

import SwiftUI
import CoreData

@main
struct CoreDataConcurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataStore.shared.persistentContainer.viewContext)
        }
    }
}
