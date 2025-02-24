//
//  ContainerTabView.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/02/2025.
//

import SwiftUI

struct ContainerTabView: View {
    
    let cancelTaskDemonstrator = CancelTaskDemonstrator()
    let errorHandlingDemonstrator = ErrorHandlingDemonstrator()
    let detachedTasksDemonstrator = DetachedTasksDemonstrator()
    
    var body: some View {
        TabView {
            ImageContentView()
                .tabItem {
                    Label("Home", systemImage: "photo.artframe")
                }

            SearchArticleView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }.task {
            await cancelTaskDemonstrator.parentTaskCancelationExample()
        }.task {
            await errorHandlingDemonstrator.throwingTaskExample()
            await errorHandlingDemonstrator.nonthrowingTaskExample()
            await errorHandlingDemonstrator.errorHandlingInTaskBodyExample()
        }.task {
            await detachedTasksDemonstrator.detachedTaskPrintExample()
            await detachedTasksDemonstrator.detachedTaskCancelationExample()
        }
    }
}
