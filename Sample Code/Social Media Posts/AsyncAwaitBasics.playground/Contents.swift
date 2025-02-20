import UIKit
import SwiftUI


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
