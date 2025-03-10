import UIKit
import SwiftUI
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/**: This playground contains the code examples used throughout the lessons in Module 2.
 First up, an async image fetcher:
 */

struct ImageFetcher {
    
    let imageURLs: [URL]
    
    func fetchImages() async throws -> [UIImage] {
        // .. perform data request
        
        return []
    }
    
    func fetchImages(_ completion: @escaping (_ result: Result<[UIImage], Error>) -> Void) {
        // .. perform data request
    }
}

Task {
    let imageFetcher = ImageFetcher(imageURLs: [
        // some image URLs
    ])
    
    let images = try await imageFetcher.fetchImages()
}
//: Basic `async let` example:
func fetchData(_ id: Int) async -> String {
    return "Data \(id)"
}

func loadAllData() async {
    async let data1 = fetchData(1)
    async let data2 = fetchData(2)
    async let data3 = fetchData(3)

    let results = await [data1, data2, data3]
    print(results) // Output: ["Data 1", "Data 2", "Data 3"]
}
await loadAllData()
//: Basic `async let` example with a failure:
func fetchDataWithPotentialFailure(_ id: Int) async throws -> String {
    if id == 2 {
        // Simulating an error for id `2`.
        throw URLError(.badServerResponse)
    }
    return "Data \(id)"
}

func loadAllDataWithFailure() async {
    async let data1 = fetchDataWithPotentialFailure(1)
    async let data2 = fetchDataWithPotentialFailure(2) // This throws an error
    async let data3 = fetchDataWithPotentialFailure(3)

    do {
        let results = try await [data1, data2, data3]
        print(results)
    } catch {
        print("Error occurred: \(error)")
    }
    // data1 and data3 are **implicitly canceled** when exiting scope
}
await loadAllDataWithFailure()
//: Defining an async article title fetcher and three article URLs to use in further demonstrations.
struct ArticleTitleFetcher {
    
    func fetchTitle(for url: URL) async throws -> String {
        print("Fetching title for \(url)")

        let (data, _) = try await URLSession.shared.data(from: url)
        
        print("Finished Fetching title for \(url)")
        
        guard let htmlString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return extractTitle(from: htmlString) ?? "Untitled"
    }
    
    private func extractTitle(from html: String) -> String? {
        guard let range = html.range(of: "<title>(.*?)</title>", options: .regularExpression) else {
            return nil
        }
        return String(html[range])
            .replacingOccurrences(of: "<title>", with: "")
            .replacingOccurrences(of: "</title>", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

let articleURLOne = URL(string: "https://www.avanderlee.com/swiftui/how-to-develop-an-app-for-ios/")!
let articleURLTwo = URL(string: "https://www.avanderlee.com/swift-testing/parameterized-tests-reducing-boilerplate-code/")!
let articleURLThree = URL(string: "https://www.avanderlee.com/swift/result-builders/")!
//: Example 1: Fetch titles in synchronous order without using `async let`
func fetchTitlesInOrder() async throws {
    let fetcher = ArticleTitleFetcher()
    
    let titleOne = try await fetcher.fetchTitle(for: articleURLOne)
    let titleTwo = try await fetcher.fetchTitle(for: articleURLTwo)
    let titleThree = try await fetcher.fetchTitle(for: articleURLThree)
    
    print("Title 3: \(titleThree)")
    print("Title 2: \(titleTwo)")
    print("Title 1: \(titleOne)")
}
/*:
 Example 2: Fetch article titles in parallel using `async let`.
 - Note: the `try await` is not required when using `async let` and can be skipped (see example 3)
*/
func fetchTitlesInParallel() async throws {
    let fetcher = ArticleTitleFetcher()

    print("Defining title one")
    async let titleOne = try await fetcher.fetchTitle(for: articleURLOne)
    
    /// Add a sleep to demonstrate that title one starts executing right away.
    try await Task.sleep(nanoseconds: 1_000_000_000)
    
    print("Defining title two and three")
    async let titleTwo = try await fetcher.fetchTitle(for: articleURLTwo)
    async let titleThree = try await fetcher.fetchTitle(for: articleURLThree)

    let titles = try await [titleOne, titleTwo, titleThree]
    print(titles.joined(separator: ", "))
}
//: Example 3: Similar to example 2, but we're only awaiting the final array of results.
func fetchTitlesInParallelAwaitingArray() async throws {
    let fetcher = ArticleTitleFetcher()

    print("Defining title one")
    async let titleOne = fetcher.fetchTitle(for: articleURLOne)
    
    /// Add a sleep to demonstrate that title one starts executing right away.
    try await Task.sleep(nanoseconds: 1_000_000_000)
    
    print("Defining title two and three")
    async let titleTwo = fetcher.fetchTitle(for: articleURLTwo)
    async let titleThree = fetcher.fetchTitle(for: articleURLThree)

    print("Awaiting results in array")
    let titles = try await [titleOne, titleTwo, titleThree]
    print(titles.joined(separator: ", "))
}

try await fetchTitlesInParallelAwaitingArray()
//: ## Social media question, interesting for this playground as well:
//: Define a fetcher who uses a `URLSession` data request to get the <title></title> contents.
let fetcher = ArticleTitleFetcher()
//: Fetch the webpage titles for 3 different webpages:
async let titleOne = try await fetcher.fetchTitle(for: URL(string: "https://www.avanderlee.com/swiftui/how-to-develop-an-app-for-ios/")!)
async let titleTwo = try await fetcher.fetchTitle(for: URL(string: "https://www.avanderlee.com/swift-testing/parameterized-tests-reducing-boilerplate-code/")!)
async let titleThree = try await fetcher.fetchTitle(for: URL(string: "https://www.avanderlee.com/swift/result-builders/")!)
//: Wait for all the requests to finish by using an array:
let titles = try await [titleOne, titleTwo, titleThree]
/*:
 **QUESTION:**
 > Which of the requests finishes first: titleOne, titleTwo, or titleThree?
 */
/*: ##### QUESTION
 ## Which of these points will run on the main thread?*/
struct ThreadingQuestion {
    
    @MainActor
    func updateUI() {
        Task {
            /// Point 1
            
            await someOtherTask()
            
            /// Point 3
        }
    }
    
    func someOtherTask() async {
        /// Point 2
    }
}



