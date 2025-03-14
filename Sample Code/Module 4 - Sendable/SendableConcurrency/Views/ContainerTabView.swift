//
//  ContainerTabView.swift
//  SendableConcurrency
//
//  Created by A.J. van der Lee on 14/03/2025.
//

import SwiftUI

struct ContainerTabView: View {
    
    var body: some View {
        TabView {
            DemonstratorsTabView()
                .tabItem {
                    Label("Demonstrators", systemImage: "gearshape")
                }
        }
    }
}
