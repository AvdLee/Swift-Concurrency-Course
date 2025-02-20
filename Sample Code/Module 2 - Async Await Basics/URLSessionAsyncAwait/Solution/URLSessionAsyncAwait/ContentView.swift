//
//  ContentView.swift
//  URLSessionAsyncAwait
//
//  Created by A.J. van der Lee on 04/11/2024.
//

import SwiftUI

/// This is just a simple content view to help you perform the request while debugging.
/// Note that we don't care about proper error handling and such: we just focus on rewriting the `URLSession` logic.
struct ContentView: View {
    
    let apiProvider = APIProvider()
    
    @State var responseData: PostData?
    
    var body: some View {
        VStack {
            Image(systemName: "network")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, URLSession!")
                .font(.title)
                .padding(.bottom)
            
            if let responseData {
                Text("Name is \(responseData.name) and age \(responseData.age).")
            } else {
                Text("No response yet, perform a POST request with parameters.")
            }
            
            VStack(spacing: 10) {
                Button("Perform POST Request", action: {
                    Task {
                        responseData = try await apiProvider.performPOSTURLRequest()
                    }
                })
            }.buttonStyle(.bordered).buttonBorderShape(.capsule).bold().padding(.top, 20)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
