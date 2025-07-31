//
//  GlobalActorIsolationConformance.swift
//  ActorsConcurrency
//
//  Created by A.J. van der Lee on 31/07/2025.
//

import Foundation

@MainActor
final class UnsafePersonViewModel {
    let id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

/// An unsafe way to conform to `Equatable` while using a global actor isolation domain.
extension UnsafePersonViewModel: Equatable {
    nonisolated static func == (lhs: UnsafePersonViewModel, rhs: UnsafePersonViewModel) -> Bool {
        /// ⚠️ Never use `assumeIsolated`, unless you really cannot find another way out.
        /// You basically step away from compile-time thread safetyness and risk runtime exceptions.
        MainActor.assumeIsolated {
            lhs.id == rhs.id && lhs.name == rhs.name
        }
    }
}

@MainActor
final class PersonViewModel {
    let id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

/// Upcoming feature `InferIsolatedConformances` allows us to write `: @MainActor Equatable`:
extension PersonViewModel: @MainActor Equatable {
    static func == (lhs: PersonViewModel, rhs: PersonViewModel) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}

struct EquatableDemonstrator {
    @MainActor
    func demonstrate() {
        let viewModel1 = PersonViewModel(id: UUID(), name: "Alice")
        let viewModel2 = PersonViewModel(id: UUID(), name: "Bob")
        
        Task.detached {
            /// Uncomment this line to show the error:
            /// Main actor-isolated operator function '==' cannot be called from outside of the actor
//            let theSame = viewModel1 == viewModel2
        }
    }
}

