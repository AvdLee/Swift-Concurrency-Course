//
//  IntroductionToActors.swift
//  ActorsConcurrency
//
//  Created by A.J. van der Lee on 25/03/2025.
//

private actor BankAccount {
    var balance: Int = 0

    func deposit(_ amount: Int) {
        balance += amount
    }

    func getBalance() -> Int {
        return balance
    }
}

struct IntroductionToActorsDemonstrator {
    func demonstrate() async {
        let actor = BankAccount()
        await actor.deposit(1)
        print(await actor.balance)
    }
}
