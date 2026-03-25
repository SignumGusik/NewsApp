//
//  NewsTheme.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import UIKit


// Visual theme shared by all screens.
enum NewsTheme {
    enum Colors {
        static let backgroundTop = UIColor(red: 0.98, green: 0.95, blue: 1.00, alpha: 1.0)
        static let backgroundMiddle = UIColor(red: 0.93, green: 0.97, blue: 1.00, alpha: 1.0)
        static let backgroundBottom = UIColor(red: 1.00, green: 0.97, blue: 0.95, alpha: 1.0)

        static let accent = UIColor.systemIndigo
        static let accentSoft = UIColor.systemIndigo.withAlphaComponent(0.12)
        static let hotPink = UIColor.systemPink
        static let gold = UIColor(red: 0.96, green: 0.73, blue: 0.25, alpha: 1.0)
        static let mint = UIColor.systemMint
    }

    enum Metrics {
        static let horizontalInset: CGFloat = 16
        static let cardCornerRadius: CGFloat = 28
        static let imageCornerRadius: CGFloat = 24
        static let cardShadowRadius: CGFloat = 20
    }
}
