//
//  NewsAssembly.swift
//  HW5
//
//  Created by Диана on 24/03/2026.
//

import UIKit

enum NewsAssembly {
    static func build() -> UIViewController {
        // Manual dependency wiring for the News module.
        // Keeps creation logic out of AppDelegate and out of the view controller.
        let view = NewsViewController()
        let interactor = NewsInteractor()
        let presenter = NewsPresenter()
        let router = NewsRouter()

        view.interactor = interactor

        interactor.presenter = presenter
        interactor.router = router

        presenter.view = view
        router.viewController = view

        return view
    }
}
