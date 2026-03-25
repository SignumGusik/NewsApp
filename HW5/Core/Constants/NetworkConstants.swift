//
//  NetworkConstants.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import Foundation

// Centralized networking configuration for the news API.
enum NetworkConstants {
    static let apiBaseURL = "https://news.myseldon.com/api/Section"
    static let articleBaseURL = "https://news.myseldon.com/ru/news/index/"
    static let defaultRubricID = 4
    static let defaultPageSize = 8

    enum QueryItems {
        static let rubricID = "rubricId"
        static let pageSize = "pageSize"
        static let pageIndex = "pageIndex"
        static let requestID = "requestId"
    }
}

enum VKShareConstants {
    // VK web share endpoint.
    static let shareBaseURL = "https://vk.com/share.php"

    enum QueryItems {
        static let url = "url"
    }
}
