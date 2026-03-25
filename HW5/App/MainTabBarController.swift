//
//  MainTabBarController.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
}

private extension MainTabBarController {
    func setupTabs() {
        let newsViewController = UINavigationController(rootViewController: NewsAssembly.build())
        let favoritesViewController = UINavigationController(rootViewController: FavoritesViewController())

        newsViewController.tabBarItem = UITabBarItem(
            title: TabBarConstants.NewsTab.title,
            image: UIImage(systemName: TabBarConstants.NewsTab.image),
            selectedImage: UIImage(systemName: TabBarConstants.NewsTab.selectedImage)
        )

        favoritesViewController.tabBarItem = UITabBarItem(
            title: TabBarConstants.FavoritesTab.title,
            image: UIImage(systemName: TabBarConstants.FavoritesTab.image),
            selectedImage: UIImage(systemName: TabBarConstants.FavoritesTab.selectedImage)
        )

        viewControllers = [newsViewController, favoritesViewController]
    }

    func setupAppearance() {
        tabBar.tintColor = NewsTheme.Colors.accent
        tabBar.backgroundColor = .systemBackground
    }
}
