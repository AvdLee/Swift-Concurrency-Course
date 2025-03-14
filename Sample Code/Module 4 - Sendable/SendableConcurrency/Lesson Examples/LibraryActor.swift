//
//  IsolationDomains.swift
//  SendableConcurrency
//
//  Created by A.J. van der Lee on 14/03/2025.
//

actor Library {
    var books: [String] = []

    func addBook(_ title: String) {
        books.append(title)
    }

    func getBookList() -> [String] {
        return books
    }

    nonisolated func libraryName() -> String {
        "A library of books"
    }
}
