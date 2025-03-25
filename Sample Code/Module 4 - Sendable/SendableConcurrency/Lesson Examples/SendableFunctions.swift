//
//  SendableFunctions.swift
//  SendableConcurrency
//
//  Created by A.J. van der Lee on 19/03/2025.
//

import Foundation

private struct Contact {
    let name: String
}

fileprivate actor ContactsStore {
    private(set) var contacts: [Contact] = []
    
    func add(_ contacts: [Contact]) {
        self.contacts.append(contentsOf: contacts)
    }
    
    func removeAll(_ shouldBeRemoved: (Contact) -> Bool) async {
        contacts.removeAll { contact in
            return shouldBeRemoved(contact)
        }
    }
}

private extension ContactsStore {
    /// Note that we've added the `@Sendable` attribute:
    nonisolated func cleanUpContactsInTheBackground(_ shouldBeRemoved: @escaping @Sendable (Contact) -> Bool) {
        Task(priority: .background) {
            await removeAll { contact in
                return shouldBeRemoved(contact)
            }
        }
    }
}

struct ContactsStoreDemonstrator {
    private let store = ContactsStore()
    
    func demonstrate() {
        Task {
            await store.add([
                Contact(name: "Antoine van der Lee"),
                Contact(name: "Jordi Bruin"),
                Contact(name: "Hidde van der Ploeg"),
                Contact(name: "Niels Mouthaan")
            ])

            var searchQuery = "van der"
            searchQuery.append(" Lee")
            
            /// Without [searchQuery], this would result in a Sendable error:
            /// Error: Reference to captured var 'searchQuery' in concurrently-executing code
            store.cleanUpContactsInTheBackground { [searchQuery] contact in
                contact.name.contains(searchQuery)
            }
        }
    }
}
