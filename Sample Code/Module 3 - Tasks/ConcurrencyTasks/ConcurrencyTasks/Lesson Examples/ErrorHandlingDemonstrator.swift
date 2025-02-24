//
//  ErrorHandlingDemonstrator.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/02/2025.
//

import Foundation

struct ErrorHandlingDemonstrator {
    func throwingTaskExample() async {
        let throwingTask: Task<String, Error> = Task { () -> String in
            throw URLError(.badURL)
        }

        do {
            let outputValue = try await throwingTask.value
            print(outputValue)
        } catch {
            print("The task failed with error \(error)")
        }
    }
    
    func nonthrowingTaskExample() async {
        let nonthrowingTask: Task<String, Never> = Task { () -> String in
            "Hello, World!"
        }
        print(await nonthrowingTask.value)
    }
    
    func errorHandlingInTaskBodyExample() async {
        let inputURL = URL(string: "https://www.avanderlee.com")!
        
        let handlingErrorsInBody: Task<String, Never> = Task {
            do {
                guard !inputURL.isFileURL else {
                    throw URLError(.badURL)
                }
                
                /// .. Simulate network request
                
                return "Fetched data from \(inputURL)"
            } catch {
                return "Fetching data failed for \(inputURL) with error \(error)"
            }
        }
        print(await handlingErrorsInBody.value)
    }
}
