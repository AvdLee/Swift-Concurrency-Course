//
//  RegionBasedIsolation.swift
//  SendableConcurrency
//
//  Created by A.J. van der Lee on 19/03/2025.
//

private class Article {
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

private actor ArticleEditor {
    func formatTitleForArticle(_ article: sending Article) {
        print(article.title)
    }
}

private struct SendableChecker: Sendable {
    /// This method demonstrates region-based sendable isolation checking.
    func check() {
        /// Even though this type is non-sendable, the compiler successfully builds due to region-based isolation.
        let article = Article(title: "Swift Concurrency")
        
        Task {
            /// `article` is only used here, so the compiler knows there's no risk of data races.
            print(article.title)
        }
        
        /// Enabling this line would introduce a potential data race and the compiler will start complaining.
        // print(article.title)
    }
    
    /// Since the `createArticle` is using the `sending` keyword, it tells that the resulting `Article` comes from a
    /// local (disconnected) region. Therefore, we can safely use the resulting value in the print statement later.
    func sendingResultValueCheck() async {
        let article = await createArticle(title: "some title")
        print(article.title)
    }
    
    /// By using `sending` here we're basically saying that the constructed `Article` comes from a
    /// local region. There's no way the result value will be accessed concurrently, since it stays within
    /// the scope of this `createArticle` method.
    @SomeGlobalActor
    func createArticle(title: String) -> sending Article {
        return Article(title: title)
    }
    
    func sendingParameterValueCheck() async {
        let article = Article(title: "Swift Concurrency")

        await printArticleTitle(article: article)
    
        /// Enabling this line will cause a compiler error: "Sending 'article' risks causing data races".
        // print(article.title)
    }

    /// By using the `sending` keyword, we enforce ownership transfer of the `article` value.
    /// We basically move the local-region checks toward the inner body of this method
    /// and we ensure the value cannot be accessed from the original location anymore.
    func printArticleTitle(article: sending Article) async {
        let articleTitleLogger = ArticleTitleLogger()
        await articleTitleLogger.log(article: article)
    }
}

private actor ArticleTitleLogger {
    func log(article: Article) {
        print(article.title)
    }
}

@globalActor
private actor SomeGlobalActor: GlobalActor {
    static let shared: SomeGlobalActor = SomeGlobalActor()
}
