//
//  NewsUIConstants.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import UIKit

// Shared layout, animation and typography constants for the UI layer.
enum NewsUIConstants {
    enum Insets {
        static let zero: CGFloat = 0
        static let xSmall: CGFloat = 8
        static let small: CGFloat = 10
        static let medium: CGFloat = 12
        static let regular: CGFloat = 14
        static let large: CGFloat = 16
        static let xLarge: CGFloat = 18
        static let xxLarge: CGFloat = 20
        static let huge: CGFloat = 24
        static let bottomCard: CGFloat = 14
    }

    enum Sizes {
        static let headerCornerRadius: CGFloat = 26
        static let cardCornerRadius: CGFloat = 28
        static let imageCornerRadius: CGFloat = 24
        static let detailWebCornerRadius: CGFloat = 22
        static let loadingCardCornerRadius: CGFloat = 24

        static let buttonHeight: CGFloat = 44
        static let arrowContainer: CGFloat = 36
        static let arrowIcon: CGFloat = 16
        static let newsHeroHeight: CGFloat = 210
    }

    enum Fonts {
        static let screenTitle: CGFloat = 34
        static let articleTitle: CGFloat = 28
        static let articleDescription: CGFloat = 15
        static let loadingTitle: CGFloat = 18
        static let loadingSubtitle: CGFloat = 14
        static let emptyState: CGFloat = 18
        static let cellTitle: CGFloat = 24
        static let cellDescription: CGFloat = 15
    }

    enum Lines {
        static let single = 1
        static let two = 2
        static let three = 3
    }

    enum Animation {
        static let tapDown: TimeInterval = 0.14
        static let tapUp: TimeInterval = 0.16
        static let shimmer: TimeInterval = 1.0
        static let imageTransition: TimeInterval = 0.3
        static let loadingFade: TimeInterval = 0.25
        static let highlight: TimeInterval = 0.18
    }

    enum Table {
        static let estimatedRowHeight: CGFloat = 320
        static let bottomInset: CGFloat = 32
        static let topInset: CGFloat = 12
    }

    enum Gradient {
        static let startPoint = CGPoint(x: 0, y: 0)
        static let endPoint = CGPoint(x: 1, y: 1)

        static let shimmerStartPoint = CGPoint(x: 0, y: 0.5)
        static let shimmerEndPoint = CGPoint(x: 1, y: 0.5)

        static let shimmerLocations: [NSNumber] = [0.0, 0.5, 1.0]
        static let imageOverlayLocations: [NSNumber] = [0.0, 0.45, 1.0]
    }

    enum Alpha {
        static let cardBackground: CGFloat = 0.72
        static let webContainerBackground: CGFloat = 0.88
        static let shadowOpacity: Float = 0.08
        static let highlightedShadowOpacity: Float = 0.14

        static let darkOverlayLight: CGFloat = 0.08
        static let darkOverlayStrong: CGFloat = 0.65
    }

    enum Transform {
        static let highlightedScale: CGFloat = 0.98
        static let selectedScale: CGFloat = 0.96
        static let selectedAlpha: CGFloat = 0.92
    }
}
