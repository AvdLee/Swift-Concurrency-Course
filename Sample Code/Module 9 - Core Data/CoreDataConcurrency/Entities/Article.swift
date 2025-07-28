//
//  Article.swift
//  CoreDataConcurrency
//
//  Created by A.J. van der Lee on 28/07/2025.
//
//

public import Foundation
public import CoreData

@objc(Article)
public final class Article: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var title: String
    
    /// Derived Attribute using `now()`.
    @NSManaged public private(set) var timestamp: Date
}
