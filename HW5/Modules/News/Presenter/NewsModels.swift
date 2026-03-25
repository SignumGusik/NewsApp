//
//  NewsModels.swift
//  HW5
//
//  Created by Диана on 24/03/2026.
//

import Foundation

struct NewsCellViewModel {
    let title: String
    let description: String
    let imageURL: URL?
}

struct NewsViewModel {
    let cells: [NewsCellViewModel]
}
