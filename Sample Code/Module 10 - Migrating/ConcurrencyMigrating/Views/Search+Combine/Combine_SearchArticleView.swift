//
//  Combine_SearchArticleView.swift
//  ConcurrencyMigrating
//
//  Created by A.J. van der Lee on 01/07/2025.
//

import SwiftUI
import Combine

struct Combine_SearchArticleView: View {
    @StateObject private var articleSearcher = Combine_ArticleSearcher()

    var body: some View {
        NavigationStack {
            List {
                ForEach(articleSearcher.searchResults, id: \.self) { title in
                    Text(title)
                }
            }
        }
        .searchable(text: $articleSearcher.searchQuery)
    }
}

#Preview {
    Combine_SearchArticleView()
}
