//
//  ConcurrencyCoreDataApp.swift
//  ConcurrencyCoreData
//
//  Created by A.J. van der Lee on 28/07/2025.
//

import SwiftUI
import CoreData

@main
struct ConcurrencyCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
