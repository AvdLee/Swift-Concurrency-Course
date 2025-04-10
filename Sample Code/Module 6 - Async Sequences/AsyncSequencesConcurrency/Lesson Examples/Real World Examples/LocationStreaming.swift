//
//  LocationStreaming.swift
//  AsyncSequencesConcurrency
//
//  Created by A.J. van der Lee on 10/04/2025.
//

import Foundation
import CoreLocation

@MainActor
final class LocationStreamingDemonstrator {
    func demonstrate() async {
        let locationMonitor = LocationMonitor()

        do {
            for try await location in locationMonitor.stream {
                print("Got location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            }
            print("Finished monitoring locations")
        } catch {
            print("Location stream finished with error: \(error.localizedDescription)")
        }
    }
}

final class LocationMonitor: NSObject {
    let locationManager = CLLocationManager()
    private var continuation: AsyncThrowingStream<CLLocation, Error>.Continuation?
    let stream: AsyncThrowingStream<CLLocation, Error>
    
    override init() {
        var capturedContinuation: AsyncThrowingStream<CLLocation, Error>.Continuation?
        stream = AsyncThrowingStream { continuation in
            capturedContinuation = continuation
        }
        super.init()
        self.continuation = capturedContinuation
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationMonitor: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            continuation?.yield(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.finish(throwing: error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .denied || status == .restricted {
            /// No specific error object for denied/restricted
            continuation?.finish(throwing: nil)
        }
    }
}
