//
//  SearchArticleView.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/02/2025.
//

import SwiftUI

struct SearchArticleView: View {
    @State private var searchQuery = ""

    private var articleSearcher = ArticleSearcher()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(articleSearcher.searchResults, id: \.self) { title in
                        Text(title)
                    }
                } header: {
                    if searchQuery.isEmpty {
                        Text("All articles")
                    } else {
                        Text("Search results for: \(searchQuery)")
                    }
                }
            }.navigationTitle("Search Sleep Example")
                .navigationBarTitleDisplayMode(.inline)
        }.searchable(text: $searchQuery)
            .onChange(of: searchQuery, { oldValue, newValue in
                articleSearcher.search(newValue)
            })
    }
}
