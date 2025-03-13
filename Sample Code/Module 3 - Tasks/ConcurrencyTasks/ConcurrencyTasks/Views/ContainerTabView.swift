//
//  ContainerTabView.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/02/2025.
//

import SwiftUI

struct ContainerTabView: View {
    
    var body: some View {
        TabView {
            DemonstratorsTabView()
                .tabItem {
                    Label("Demonstrators", systemImage: "gearshape")
                }
            
            ImageContentView()
                .tabItem {
                    Label("Home", systemImage: "photo.artframe")
                }

            SearchArticleTaskModifierView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}
