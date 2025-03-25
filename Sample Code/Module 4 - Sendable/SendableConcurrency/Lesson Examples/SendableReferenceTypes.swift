//
//  Counter.swift
//  SendableConcurrency
//
//  Created by A.J. van der Lee on 18/03/2025.
//

import CoreLocation

@MainActor
private class Counter {
    var value: Int = 0
}

struct Purchaser {
    func purchase() {
        /// ... purchase logic
    }
}

final class GameCreditsPurchaser {
    var purchasedCredits: Int = 0
    
    let purchaser: Purchaser = Purchaser()
}

/// Even though we use a parent class, we can mark it as `Sendable`.
/// This is only possible with `NSObject`.
final class LocationUpdatesReceiver: NSObject, CLLocationManagerDelegate, Sendable {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Updated location: \(location.coordinate)")
    }
}

struct ReferenceTypeDemonstrator {
    @MainActor
    func demonstrate() {
        let firstCounter = Counter()

        /// Creates another reference to the same object:
        let secondCounter = firstCounter

        /// Even though we increment `secondCounter` only:
        secondCounter.value += 1

        /// `firstCounter` changes as well since we use the same object reference:
        print(firstCounter.value) // 1
    }
}

