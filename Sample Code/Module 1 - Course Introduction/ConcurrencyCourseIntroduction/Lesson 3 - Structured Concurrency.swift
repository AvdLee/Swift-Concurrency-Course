//
//  Lesson 3 - Structured Concurrency.swift
//  ConcurrencyCourseIntroduction
//
//  Created by A.J. van der Lee on 19/02/2025.
//

import Foundation

struct ClosureFetcher {
    func fetchData(completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.global().async {
            sleep(1) // Simulating network delay
            completion(.success("Data"))
        }
    }

    func loadData() {
        fetchData { result1 in
            switch result1 {
            case .success(let data1):
                fetchData { result2 in
                    switch result2 {
                    case .success(let data2):
                        fetchData { result3 in
                            switch result1 {
                            case .success(let data3):
                                fetchData { result2 in
                                    print("Finished loading: \(data1), \(data2), \(data3)")
                                }
                            case .failure:
                                print("Request 3 failed!")
                            }
                        }
                    case .failure:
                        print("Request 2 failed!")
                    }
                }
            case .failure:
                print("Request 1 failed!")
            }
        }
    }
}

struct StructuredConcurrencyFetcher {
    private func fetchData(index: Int) async throws -> String {
        print("Fetching data for index \(index)")
        try Task.checkCancellation()
        
        /// Perform networking request...
        sleep(1) // Simulating network delay
        return "Data \(index)"
    }

    private func loadData() async throws {
        let data1 = try await fetchData(index: 1)
        let data2 = try await fetchData(index: 2)
        let data3 = try await fetchData(index: 3)

        print("Finished loading: \(data1), \(data2), \(data3)")
    }
    
    func synchronousMethod() {
        /// Transitioning to a concurrency context using `Task`:
        let parentTask = Task {
            async let childTask1 = fetchData(index: 1)
            async let childTask2 = fetchData(index: 2)
            async let childTask3 = fetchData(index: 3)
            
            let isCancelled = Task.isCancelled
            print("Finished loading: \(try await childTask1), \(try await childTask2), \(try await childTask3) (cancelled: \(isCancelled))")
        }
        parentTask.cancel()
    }
}
