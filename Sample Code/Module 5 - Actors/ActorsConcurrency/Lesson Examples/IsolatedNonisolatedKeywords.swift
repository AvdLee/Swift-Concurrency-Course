//
//  IsolatedNonisolatedKeywords.swift
//  ActorsConcurrency
//
//  Created by A.J. van der Lee on 25/03/2025.
//

private actor BankAccount {
    enum BankError: Error {
        case insufficientFunds
    }
    
    let accountHolder: String
    var balance: Double
    
    nonisolated var details: String {
        "Account holder: \(accountHolder)"
    }
    
    init(initialDeposit: Double) {
        self.accountHolder = "Antoine van der Lee"
        self.balance = initialDeposit
    }
    
    func withdraw(amount: Double) throws {
        guard balance >= amount else {
            throw BankError.insufficientFunds
        }
        balance -= amount
    }

    func deposit(amount: Double) {
        balance = balance + amount
    }
}

extension BankAccount: CustomStringConvertible {
    nonisolated var description: String {
        "Account holder: \(accountHolder)"
    }
}

private struct Charger {
    static func charge(amount: Double, from bankAccount: BankAccount) async throws -> Double {
        try await bankAccount.withdraw(amount: amount)
        let newBalance = await bankAccount.balance
        return newBalance
    }
    
    /// Due to using the `isolated` keyword, we only need to await at the caller side.
    static func chargeWithIsolatedParameter(amount: Double, from bankAccount: isolated BankAccount) async throws -> Double {
        try bankAccount.withdraw(amount: amount)
        let newBalance = bankAccount.balance
        return newBalance
    }
}

struct IsolatedKeywordDemonstrator {
    func demonstrate() {
        
        /// Demonstration 1: Using an isolated parameter.
        Task {
            let bankAccount = BankAccount(initialDeposit: 100)
            let newBalance = try await Charger.chargeWithIsolatedParameter(amount: 20, from: bankAccount)
            print("New balance is \(newBalance)")
        }
        
        /// Demonstration 2: A closure with an `isolated` parameter inside the `Database` actor.
        Task {
            let database = Database()
            try await database.transaction { database in
                database.insert("<some entity>")
                database.insert("<some entity>")
                database.insert("<some entity>")
            }
        }
        
        /// Demonstration 3: Generic `Actor` extension with isolated parameter.
        Task {
            let bankAccount = BankAccount(initialDeposit: 200)
            try await bankAccount.performInIsolation { bankAccount in
                try bankAccount.withdraw(amount: 20)
                print("New balance is \(bankAccount.balance)")
            }
        }
        
        /// Demonstration 4: Nonisolated access
        let bankAccount = BankAccount(initialDeposit: 300)
        print(bankAccount.details)
        
        Task { @MainActor in
            let names = ["Antoine", "Maaike", "Sep", "Jip"]
            
            /// Enabling this would show a compiler error:
            /// Sending main actor-isolated value of type '(String) async -> String' with later accesses to nonisolated context risks causing data races
//            let lowercaseNames = await names.withoutIsolationSequentialMap { name in
//                await lowercaseWithSleep(input: name)
//            }
            let lowercaseNames = await names.withIsolationSequentialMap { name in
                await lowercaseWithSleep(input: name)
            }
            print(lowercaseNames)
        }
    }
    
    func lowercaseWithSleep(input: String) async -> String {
        try? await Task.sleep(for: .seconds(1))
        return input.lowercased()
    }
}


extension Collection where Element: Sendable {
    /// Only works for non-isolated domains.
    func withoutIsolationSequentialMap<Result: Sendable>(
        transform: (Element) async -> Result
    ) async -> [Result] {
        var results: [Result] = []
        for element in self {
            results.append(await transform(element))
        }
        return results
    }
    
    /// Works with any isolation domain as it inherits isolation via the `#isolation` macro.
    func withIsolationSequentialMap<Result: Sendable>(
        isolation: isolated (any Actor)? = #isolation,
        transform: (Element) async -> Result
    ) async -> [Result] {
        var results: [Result] = []
        for element in self {
            results.append(await transform(element))
        }
        return results
    }
}

private actor Database {
    func beginTransaction() {
        // ...
    }
    
    func commitTransaction() {
        // ...
    }
    
    func rollbackTransaction() {
        // ...
    }
    
    func insert(_ entity: String) {
        
    }
    
    /// By using an isolated `Database` parameter inside the closure, we can access `Database`-actor isolation from anywhere
    /// allowing us to perform multiple database queries with just one `await`.
    func transaction<Result>(_ transaction: @Sendable (_ database: isolated Database) throws -> Result) throws -> Result {
        do {
            beginTransaction()
            let result = try transaction(self)
            commitTransaction()
            
            return result
        } catch {
            rollbackTransaction()
            throw error
        }
    }
}

extension Actor {
    /// Adds a general `perform` method for any actor to access its isolation domain to perform
    /// multiple operations in one go using the closure.
    @discardableResult
    func performInIsolation<T: Sendable>(_ block: @Sendable (_ actor: isolated Self) throws -> T) async rethrows -> T {
        try block(self)
    }
}
