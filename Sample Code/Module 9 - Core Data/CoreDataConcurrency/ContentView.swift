//
//  ContentView.swift
//  CoreDataConcurrency
//
//  Created by A.J. van der Lee on 28/07/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Article.timestamp, ascending: true)],
        animation: .default)
    private var articles: FetchedResults<Article>

    var body: some View {
        NavigationView {
            List {
                Section("Articles") {
                    ForEach(articles) { article in
                        NavigationLink {
                            VStack {
                                Text(article.title).font(.title)
                                Text("Article was published at \(article.timestamp, formatter: articleFormatter)")
                            }
                                .navigationTitle("Core Data & Swift Concurrency")
                        } label: {
                            Text(article.timestamp, formatter: articleFormatter)
                        }
                    }
                    .onDelete(perform: deleteArticles)
                }
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addArticle) {
                        Label("Add Article", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: deleteAllArticles) {
                        Label("Delete Articles", systemImage: "trash")
                    }
                }
            }
            Text("Select or add an article")
                .navigationTitle("Core Data & Swift Concurrency")
        }
    }

    private func addArticle() {
        withAnimation {
            do {
                try CoreDataStore.shared.perform { viewContext in
                    let newArticle = Article(context: viewContext)
                    newArticle.title = "Some title"
                    try viewContext.save()
                }
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteAllArticles() {
        Task {
            try await CoreDataStore.shared.deleteAllAndSave(using: Article.fetchRequest())
        }
    }

    private func deleteArticles(offsets: IndexSet) {
        withAnimation {
            do {
                try CoreDataStore.shared.perform { viewContext in
                    offsets.map { articles[$0] }.forEach(viewContext.delete)
                    try viewContext.save()
                }
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let articleFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, CoreDataStore.shared.persistentContainer.viewContext)
}
