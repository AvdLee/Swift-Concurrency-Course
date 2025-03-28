//
//  ActorReentrancy.swift
//  ActorsConcurrency
//
//  Created by A.J. van der Lee on 27/03/2025.
//

import Foundation

struct ActorReentrancyDemonstrator {
    func demonstrate() async {
        let bankAccount = BankAccount(initialDeposit: 100)
        async let _ = bankAccount.deposit(amount: 50)
        async let _ = bankAccount.deposit(amount: 50)
        async let _ = bankAccount.deposit(amount: 50)
        
        /*
         Instead of printing:
         Balance is now 150.0
         Balance is now 200.0
         Balance is now 250.0
         
         This will print:
         Balance is now 250.0
         Balance is now 250.0
         Balance is now 250.0
         */
    }
}

private actor BankAccount {
    var balance: Double
    let activityLogger = BankAccountActivityLogger()
    
    init(initialDeposit: Double) {
        self.balance = initialDeposit
    }
    
    func deposit(amount: Double) async {
        /// We update the balance with the amount:
        balance = balance + amount
        
        /// We temporarily exit the actor isolation domain to go into the activity logger
        /// and log the activity:
        await activityLogger.log(BankAccountActivity(activity: "Increased balance by \(amount)"))
        
        /// We re-enter the actor and we print out the balance:
        print("Balance is now \(balance)")
    }
}

struct BankAccountActivity {
    let date: Date = .now
    let activity: String
}

private actor BankAccountActivityLogger {
    private var activities: [BankAccountActivity] = []
    
    func log(_ activity: BankAccountActivity) async {
        activities.append(activity)
        
        /// Adding a sleep to simulate a remote syncing of the activity.
        try? await Task.sleep(for: .seconds(1))
    }
}
