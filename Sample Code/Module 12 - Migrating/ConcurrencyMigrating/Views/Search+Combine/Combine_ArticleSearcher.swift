//
//  Combine_ArticleSearcher.swift
//  ConcurrencyMigrating
//
//  Created by A.J. van der Lee on 01/07/2025.
//

import SwiftUI
import Combine

@MainActor
final class Combine_ArticleSearcher: ObservableObject {

    private static let articleTitlesDatabase = [
        "Article one",
        "Article two",
        "Article three",
    ]

    @Published var searchResults: [String] = Combine_ArticleSearcher.articleTitlesDatabase
    @Published var searchQuery: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var currentSearchTask: Task<Void, Never>?

    init() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] query in
                guard !query.isEmpty else {
                    self?.searchResults = Self.articleTitlesDatabase
                    return
                }
                
                /// A simplified static result and search implementation.
                self?.searchResults = Self.articleTitlesDatabase
                    .filter { $0.lowercased().contains(query.lowercased()) }
            })
            .store(in: &cancellables)
    }
}
