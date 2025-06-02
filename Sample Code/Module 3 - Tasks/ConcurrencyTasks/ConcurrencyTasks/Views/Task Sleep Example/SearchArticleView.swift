//
//  SearchArticleView.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/02/2025.
//

import SwiftUI

/// Example 1: Using manual search cancellation, not using SwiftUI's `task` modifier:
struct SearchArticleView: View {
    @State private var searchQuery = ""
    @State private var articleSearcher = ArticleSearcher()

    var body: some View {
        NavigationStack {
            List {
                ForEach(articleSearcher.searchResults, id: \.self) { title in
                    Text(title)
                }
            }
        }
        .searchable(text: $searchQuery)
        .onChange(of: searchQuery) { oldValue, newValue in
            articleSearcher.search(newValue)
        }
    }
}

/// Example 2: Using automatic search cancellation by using SwiftUI's `task` modifier:
struct SearchArticleTaskModifierView: View {
    @State private var searchQuery = ""
    @State private var articleSearcher = ArticleSearcher()

    var body: some View {
        NavigationStack {
            List {
                ForEach(articleSearcher.searchResults, id: \.self) { title in
                    Text(title)
                }
            }
        }
        .searchable(text: $searchQuery)
        .task(id: searchQuery, priority: .userInitiated) {
            await articleSearcher.search(searchQuery)
        }
    }
}
