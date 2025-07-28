//
//  Concurrency_SearchArticleView.swift
//  ConcurrencyMigrating
//
//  Created by A.J. van der Lee on 01/07/2025.
//

import SwiftUI
import Combine

struct Concurrency_SearchArticleView: View {
    @State private var searchQuery = ""
    @State private var articleSearcher = Concurrency_ArticleSearcher()

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

#Preview {
    Concurrency_SearchArticleView()
}
