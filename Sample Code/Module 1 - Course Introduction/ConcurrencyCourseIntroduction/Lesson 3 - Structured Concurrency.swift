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
    func fetchData() async throws -> String {
        sleep(1) // Simulating network delay
        return "Data"
    }

    func loadData() async throws {
        let data1 = try await fetchData()
        let data2 = try await fetchData()
        let data3 = try await fetchData()
        
        print("Finished loading: \(data1), \(data2), \(data3)")
    }
}
