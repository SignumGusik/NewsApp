//
//  NewsPresenter.swift
//  HW5
//
//  Created by Диана on 24/03/2026.
//

final class NewsPresenter: NewsPresentationLogic {

    weak var view: NewsViewProtocol?

    func presentNews(articles: [ArticleModel]) {
        // Presenter converts entities into lightweight view models,
        // so the view does not depend on API-facing model details.
        let cells = articles.map {
            NewsCellViewModel(
                title: $0.displayTitle,
                description: $0.description,
                imageURL: $0.imageURL
            )
        }

        view?.displayNews(viewModel: NewsViewModel(cells: cells))
    }

    func presentError(message: String) {
        view?.displayError(message: message)
    }
}
