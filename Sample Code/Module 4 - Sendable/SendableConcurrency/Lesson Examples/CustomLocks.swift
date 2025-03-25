//
//  CustomLocks.swift
//  SendableConcurrency
//
//  Created by A.J. van der Lee on 25/03/2025.
//

import Foundation

/// This class represents an example of what might be an existing class in your codebase.
/// You should see this as such representation, not as best-practice code. It's better to use an `actor` in modern concurrency.
final class BankAccount: @unchecked Sendable {
    private var balance: Int = 0
    private let lock = NSLock()

    func deposit(amount: Int) {
        lock.lock()
        balance += amount
        lock.unlock()
    }

    func withdraw(amount: Int) {
        lock.lock()
        if balance >= amount {
            balance -= amount
        }
        lock.unlock()
    }

    func getBalance() -> Int {
        lock.lock()
        let currentBalance = balance
        lock.unlock()
        return currentBalance
    }
}

actor BankAccountActor {
    private var balance: Int = 0

    func deposit(amount: Int) {
        balance += amount
    }

    func withdraw(amount: Int) {
        if balance >= amount {
            balance -= amount
        }
    }

    func getBalance() -> Int {
        return balance
    }
}
