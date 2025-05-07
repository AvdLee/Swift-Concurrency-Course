//
//  ActorReentrancyDemonstrator.swift
//  ConcurrencyThreading
//
//  Created by A.J. van der Lee on 06/05/2025.
//

struct ActorReentrancyDemonstrator {
    func demonstrate() {
        let account = BankAccount()

        Task {
            await withTaskGroup(of: Void.self) { group in
                for _ in 1...2 {
                    group.addTask {
                        await account.deposit(amount: 100)
                    }
                }
            }
        }
    }
}

actor BankAccount {
    private var balance: Int = 0

    func deposit(amount: Int) async {
        balance += amount
        print("[\(balance)] Deposited \(amount), balance is now \(balance)")

        await logTransaction(amount) // ⚠️ Suspension point

        balance += 10 // bonus after logging
        print("[\(balance)] Applied bonus, balance is now \(balance)")
    }

    private func logTransaction(_ amount: Int) async {
        try? await Task.sleep(for: .seconds(1)) // Simulate async logging.
        print("[logTransaction] Logged deposit of \(amount)")
    }
}
