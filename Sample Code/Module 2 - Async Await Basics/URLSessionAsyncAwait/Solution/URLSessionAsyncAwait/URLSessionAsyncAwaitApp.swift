//
//  URLSessionAsyncAwaitApp.swift
//  URLSessionAsyncAwait
//
//  Created by A.J. van der Lee on 04/11/2024.
//

import SwiftUI

@main
struct URLSessionAsyncAwaitApp: App {
    
    init () {
        loadRocketSimConnect()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func loadRocketSimConnect() {
        #if DEBUG
        guard (Bundle(path: "/Users/avanderlee/Library/Developer/Xcode/DerivedData/RocketSim-bsonzuojoakagifdrthvwdxfmfjm/Build/Products/Debug/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework")?.load() == true) else {
            print("Failed to load linker framework")
            return
        }
        print("RocketSim Connect successfully linked")
        #endif
    }
}
