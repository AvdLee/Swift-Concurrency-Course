import UIKit
import SwiftUI

/// This playground is not super useful for you as a student, but mostly contains the code examples used throughout the lessons.

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

func fetchTitlesInOrder() async throws {
    let fetcher = ArticleTitleFetcher()
    
    let titleOne = try await fetcher.fetchTitle(for: articleURLOne)
    let titleTwo = try await fetcher.fetchTitle(for: articleURLTwo)
    let titleThree = try await fetcher.fetchTitle(for: articleURLThree)
    
    print("Title 3: \(titleThree)")
    print("Title 2: \(titleTwo)")
    print("Title 1: \(titleOne)")
}

func fetchTitlesInParallel() async throws {
    let fetcher = ArticleTitleFetcher()

    print("Defining title one")
    async let titleOne = try await fetcher.fetchTitle(for: articleURLOne)
    
    try await Task.sleep(nanoseconds: 1_000_000_000)
    
    print("Defining title two and three")
    async let titleTwo = try await fetcher.fetchTitle(for: articleURLTwo)
    async let titleThree = try await fetcher.fetchTitle(for: articleURLThree)

    let titles = try await [titleOne, titleTwo, titleThree]
    print(titles.joined(separator: ", "))
}

try await fetchTitlesInParallel()

// Commented since it's demonstrating broken functionality.
//@Observable
//final class ContentViewModel {
//    
//    async let title = await fetchTitle()
//
//    // .. rest of your code
//}

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
