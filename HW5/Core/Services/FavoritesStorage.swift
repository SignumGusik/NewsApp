//
//  FavoritesStorage.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import Foundation

final class FavoritesStorage {
    static let shared = FavoritesStorage()

    private let userDefaults: UserDefaults
    private let favoritesKey: String

    init(
        userDefaults: UserDefaults = .standard,
        favoritesKey: String = AppConstants.StorageKeys.favoriteArticles
    ) {
        self.userDefaults = userDefaults
        self.favoritesKey = favoritesKey
    }

    func getFavorites() -> [ArticleModel] {
        guard let data = userDefaults.data(forKey: favoritesKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([ArticleModel].self, from: data)
        } catch {
            return []
        }
    }

    func isFavorite(_ article: ArticleModel) -> Bool {
        getFavorites().contains { $0.id == article.id }
    }

    func save(_ article: ArticleModel) {
        var favorites = getFavorites()

        guard favorites.contains(where: { $0.id == article.id }) == false else {
            return
        }

        // New items are inserted at the beginning
        // so the favorites tab shows the most recently saved article first.
        favorites.insert(article, at: 0)
        persist(favorites)
    }

    func remove(_ article: ArticleModel) {
        let favorites = getFavorites().filter { $0.id != article.id }
        persist(favorites)
    }

    func toggle(_ article: ArticleModel) {
        if isFavorite(article) {
            remove(article)
        } else {
            save(article)
        }
    }

    private func persist(_ articles: [ArticleModel]) {
        do {
            let data = try JSONEncoder().encode(articles)
            userDefaults.set(data, forKey: favoritesKey)
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }
}
