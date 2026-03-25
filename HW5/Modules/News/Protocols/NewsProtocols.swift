//
//  NewsProtocols.swift
//  HW5
//
//  Created by Диана on 24/03/2026.
//

import Foundation

protocol NewsBusinessLogic {
    func loadFreshNews()
    func loadMoreNews()
    func didSelectArticle(at index: Int)
}

protocol NewsDataStore {
    var articles: [ArticleModel] { get }
}

protocol NewsPresentationLogic: AnyObject {
    func presentNews(articles: [ArticleModel])
    func presentError(message: String)
}

protocol NewsViewProtocol: AnyObject {
    func displayNews(viewModel: NewsViewModel)
    func displayError(message: String)
}

protocol NewsRoutingLogic: AnyObject {
    func routeToArticleDetails(with article: ArticleModel)
}
