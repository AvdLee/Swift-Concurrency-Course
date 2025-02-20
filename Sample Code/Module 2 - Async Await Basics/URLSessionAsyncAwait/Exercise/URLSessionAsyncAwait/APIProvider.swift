//
//  APIProvider.swift
//  URLSessionAsyncAwait
//
//  Created by A.J. van der Lee on 20/02/2025.
//

import Foundation

/// Define a struct to represent the data you want to send
struct PostData: Codable {
    let name: String
    let age: Int
}

/// Define a struct to handle the response from `httpbin.org`.
struct PostResponse: Decodable {
    
    /// In this case, we can reuse the same `PostData` struct as
    /// httpbin returns the received data equally.
    let json: PostData
}

struct APIProvider {
    enum NetworkingError: Error {
        /// Used in both async/await and closure-based requests:
        case encodingFailed(innerError: EncodingError)
        case decodingFailed(innerError: DecodingError)
        case invalidStatusCode(statusCode: Int)
        case requestFailed(innerError: URLError)
        case otherError(innerError: Error)
        
        /// Only needed for closure based handling:
        case invalidResponse
    }
}

// MARK: - Using closures
extension APIProvider {
    func performPOSTURLRequest(completion: @escaping (Result<PostData, NetworkingError>) -> Void) {
        /// Configure the URL for our request.
        let url = URL(string: "https://httpbin.org/post")!

        /// Create a URLRequest for the POST request.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        /// Define the struct of data and encode it to data.
        let postData = PostData(name: "Antoine van der Lee", age: 34)

        /// Configure the JSON body and catch any failures if needed.
        do {
            request.httpBody = try JSONEncoder().encode(postData)
        } catch let error as EncodingError {
            completion(.failure(.encodingFailed(innerError: error)))
            return
        } catch {
            completion(.failure(.otherError(innerError: error)))
            return
        }
        
        /// Use URLSession to fetch the data asynchronously.
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let error {
                    throw error
                }
                
                guard let data, let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkingError.invalidResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkingError.invalidStatusCode(statusCode: httpResponse.statusCode)
                }
                
                let decodedResponse = try JSONDecoder().decode(PostResponse.self, from: data)
                print("The JSON response contains a name: \(decodedResponse.json.name) and an age: \(decodedResponse.json.age)")
                
                /// Make sure to send a completion with the success result.
                completion(.success(decodedResponse.json))
            } catch let error as DecodingError {
                completion(.failure(.decodingFailed(innerError: error)))
            } catch let error as EncodingError {
                completion(.failure(.encodingFailed(innerError: error)))
            } catch let error as URLError {
                completion(.failure(.requestFailed(innerError: error)))
            } catch let error as NetworkingError {
                completion(.failure(error))
            } catch {
                completion(.failure(.otherError(innerError: error)))
            }
        }.resume()
    }
}

extension APIProvider {
    func performPOSTURLRequest() async throws(NetworkingError) -> PostData {
        do {
            /// Configure the URL for our request.
            let url = URL(string: "https://httpbin.org/post")!
            
            /// Create a URLRequest for the POST request.
            var request = URLRequest(url: url)
            
            /// Configure the HTTP method.
            request.httpMethod = "POST"
            
            /// Configure the proper content-type value to JSON.
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            /// Define the struct of data and encode it to data.
            let postData = PostData(name: "Antoine van der Lee", age: 33)
            let jsonData = try JSONEncoder().encode(postData)
            
            /// Pass in the data as the HTTP body.
            request.httpBody = jsonData
        } catch let error as DecodingError {
            throw .decodingFailed(innerError: error)
        } catch let error as EncodingError {
            throw .encodingFailed(innerError: error)
        } catch let error as URLError {
            throw .requestFailed(innerError: error)
        } catch let error as NetworkingError {
            throw error
        } catch {
            throw .otherError(innerError: error)
        }
    }
}
