//
//  NewsRouter.swift
//  HW5
//
//  Created by Диана on 24/03/2026.
//

import UIKit

final class NewsRouter: NewsRoutingLogic {

    weak var viewController: UIViewController?

    func routeToArticleDetails(with article: ArticleModel) {
        // Routing is centralized here so the view controller
        // does not create and push destination screens directly.
        let detailsViewController = ArticleDetailsViewController(article: article)
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
