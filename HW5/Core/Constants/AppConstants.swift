//
//  AppConstants.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import Foundation

// Global app strings and symbolic names.
enum AppConstants {
    enum Titles {
        static let newsScreen = "Latest News"
        static let articleScreen = "Article"
        static let favoritesScreen = "Favorites"

        static let share = "Share"
        static let save = "Save"
        static let saved = "Saved"
        static let remove = "Remove"

        static let error = "Error"
        static let ok = "OK"

        static let loadingArticle = "Loading article"
    }

    enum Messages {
        static let failedToLoadNews = "Failed to load news."
        static let failedToLoadMoreNews = "Failed to load more news."
        static let failedToLoadArticle = "Unable to load the article."
        static let articleLinkUnavailable = "Article link is unavailable."
        static let pleaseWait = "Please wait"
        static let noSavedArticles = "No saved articles yet"
        static let vkShareUnavailable = "VK share is unavailable."
    }

    enum Symbols {
        static let share = "square.and.arrow.up"
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let arrowUpRight = "arrow.up.right"

        static let newsTab = "newspaper"
        static let newsTabSelected = "newspaper.fill"
        static let favoritesTab = "heart"
        static let favoritesTabSelected = "heart.fill"

        static let vk = "paperplane"
    }

    enum Placeholders {
        static let untitledArticle = "Untitled article"
        static let noDescription = "No description available."
        static let photoSystemName = "photo"
    }

    enum StorageKeys {
        static let favoriteArticles = "favorite_articles"
    }
}
