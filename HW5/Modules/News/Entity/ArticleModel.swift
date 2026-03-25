//
//  ArticleModel.swift
//  HW5
//
//  Created by Диана on 24/03/2026.
//

import Foundation

struct ArticleModel: Codable, Equatable, Hashable {
    var newsId: Int?
    var title: String?
    var announce: String?
    var img: ImageContainer?
    var requestId: String?

    var description: String {
        announce ?? AppConstants.Placeholders.noDescription
    }

    var imageURL: URL? {
        img?.url
    }

    var articleURL: URL? {
        guard let newsId, let requestId else { return nil }
        return URL(string: "\(NetworkConstants.articleBaseURL)\(newsId)?\(NetworkConstants.QueryItems.requestID)=\(requestId)")
    }

    var displayTitle: String {
        title ?? AppConstants.Placeholders.untitledArticle
    }

    var id: Int {
        // A stable identifier is required for favorites storage and comparison.
        newsId ?? -1
    }
}

struct ImageContainer: Codable, Equatable, Hashable {
    var url: URL?
}

struct NewsPage: Decodable {
    var news: [ArticleModel]?
    var requestId: String?

    var preparedArticles: [ArticleModel] {
        guard let requestId, let news else { return [] }

        // requestId comes from the page response, but articleURL is built per article,
        // so it is injected into every item before the list reaches the UI layer.
        return news.map { article in
            var updatedArticle = article
            updatedArticle.requestId = requestId
            return updatedArticle
        }
    }
}
