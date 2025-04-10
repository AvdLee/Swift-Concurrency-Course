//
//  PingService.swift
//  AsyncSequencesConcurrency
//
//  Created by A.J. van der Lee on 10/04/2025.
//

struct PingServiceDemonstrator {
    func demonstrate() async {
        let pingService = PingService()

        for await pingResult in pingService.startPinging() {
            print("Pinging result is: \(pingResult)")
        }
    }
}

struct PingService {
    
    func startPinging() -> AsyncStream<Bool> {
        AsyncStream<Bool> {
            try? await Task.sleep(for: .seconds(5))
            return await ping()
        } onCancel: {
            print("Cancelled pinging!")
        }
    }
    
    func ping() async -> Bool {
        /// Imagine this method pings the backend using a URLRequest.
        print("Pinging...")
        
        return true
    }
}
