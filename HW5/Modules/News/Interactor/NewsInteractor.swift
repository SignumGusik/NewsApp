//
//  NewsInteractor.swift
//  HW5
//
//  Created by Диана on 24/03/2026.
//

import Foundation

final class NewsInteractor: NewsBusinessLogic, NewsDataStore {

    var presenter: NewsPresentationLogic?
    var router: NewsRoutingLogic?

    private let worker: ArticleWorker
    private var currentPageIndex = 1
    private var isLoading = false

    var articles: [ArticleModel] = [] {
        didSet {
            presenter?.presentNews(articles: articles)
        }
    }

    init(worker: ArticleWorker = ArticleWorker()) {
        self.worker = worker
    }

    func loadFreshNews() {
        guard !isLoading else { return }
        isLoading = true
        currentPageIndex = 1

        Task {
            defer { isLoading = false }

            do {
                let freshArticles = try await worker.fetchNews(pageIndex: currentPageIndex)
                await MainActor.run {
                    self.articles = freshArticles
                }
            } catch {
                await MainActor.run {
                    self.presenter?.presentError(message: AppConstants.Messages.failedToLoadNews)
                }
            }
        }
    }

    func loadMoreNews() {
        guard !isLoading else { return }
        isLoading = true

        Task {
            defer { isLoading = false }

            do {
                let nextPage = currentPageIndex + 1
                let moreArticles = try await worker.fetchNews(pageIndex: nextPage)

                await MainActor.run {
                    self.currentPageIndex = nextPage
                    self.articles.append(contentsOf: moreArticles)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.presentError(message: AppConstants.Messages.failedToLoadMoreNews)
                }
            }
        }
    }

    func didSelectArticle(at index: Int) {
        guard articles.indices.contains(index) else { return }
        router?.routeToArticleDetails(with: articles[index])
    }
}
