//
//  TaskLocalDemonstrator.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 13/03/2025.
//

struct TaskLocalDemonstrator {
    static func demonstrate() {
        UserContext.$userId.withValue(123) {
            print("Inside Task - User ID: \(UserContext.userId ?? -1)") // Prints 123
            
            Task {
                print("Nested Task - User ID: \(UserContext.userId ?? -1)") // Prints 123
            }
            
            Task.detached {
                print("Detached Task - User ID: \(UserContext.userId ?? -1)") // Prints -1 (not inherited)
            }
        }
    }
}

enum UserContext {
    @TaskLocal
    static var userId: Int?
}
