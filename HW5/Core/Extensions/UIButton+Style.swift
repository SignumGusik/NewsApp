//
//  UIButton+Style.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import UIKit

extension UIButton {
    static func makeFilled(
        title: String,
        imageSystemName: String? = nil
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.applyFilledStyle(title: title, imageSystemName: imageSystemName)
        return button
    }

    func applyFilledStyle(title: String, imageSystemName: String? = nil) {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.cornerStyle = .large
        configuration.baseBackgroundColor = NewsTheme.Colors.accent
        configuration.baseForegroundColor = .white

        if let imageSystemName {
            configuration.image = UIImage(systemName: imageSystemName)
            configuration.imagePadding = 8
        }

        self.configuration = configuration
    }
}
