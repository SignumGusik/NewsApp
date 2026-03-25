//
//  ArticleWorker.swift
//  HW5
//
//  Created by Диана on 24/03/2026.
//

import Foundation

enum NewsError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
}

final class ArticleWorker {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let rubricId: Int
    private let pageSize: Int

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        rubricId: Int = NetworkConstants.defaultRubricID,
        pageSize: Int = NetworkConstants.defaultPageSize
    ) {
        self.session = session
        self.decoder = decoder
        self.rubricId = rubricId
        self.pageSize = pageSize
    }

    func fetchNews(pageIndex: Int) async throws -> [ArticleModel] {
        guard let url = makeURL(pageIndex: pageIndex) else {
            throw NewsError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NewsError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw NewsError.invalidStatusCode(httpResponse.statusCode)
        }

        let newsPage = try decoder.decode(NewsPage.self, from: data)
        return newsPage.preparedArticles
    }

    private func makeURL(pageIndex: Int) -> URL? {
        var components = URLComponents(string: NetworkConstants.apiBaseURL)
        components?.queryItems = [
            URLQueryItem(name: NetworkConstants.QueryItems.rubricID, value: "\(rubricId)"),
            URLQueryItem(name: NetworkConstants.QueryItems.pageSize, value: "\(pageSize)"),
            URLQueryItem(name: NetworkConstants.QueryItems.pageIndex, value: "\(pageIndex)")
        ]
        return components?.url
    }
}
