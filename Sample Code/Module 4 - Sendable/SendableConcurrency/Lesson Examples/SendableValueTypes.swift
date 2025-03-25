//
//  SendableProtocolIntroduction.swift
//  SendableConcurrency
//
//  Created by A.J. van der Lee on 17/03/2025.
//

public struct Company: Sendable {
    let name: String
}

public enum PersonRole: Sendable {
    case student
    case employee(company: Company)
    case retired(yearsOfService: Int)
    case unemployed
}

public struct Person: Sendable {
    var name: String
    var hometown: String
    var role: PersonRole
    
    init(name: String, hometown: Location, role: PersonRole) {
        self.name = name
        self.hometown = hometown.name
        self.role = role
    }
}

public struct Location {
    var name: String
}

@MainActor
struct LocationDetailViewModel { // Implicitly conforms to Sendable now.
    let location: Location
    
    init(location: sending Location) {
        self.location = location
    }
}

private struct SendableChecker: Sendable {
    let person = Person(name: "Antoine", hometown: Location(name: "Amsterdam"), role: .unemployed)
    
    func check() {
        Task {
            /// A compiler error will show up here if `person` isn't `Sendable`.
            print(person.name)
        }
    }
}

public class PersonReferenceType {
    public var name: String
    
    init(name: String) { self.name = name }
}
