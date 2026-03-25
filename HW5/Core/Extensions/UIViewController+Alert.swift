//
//  UIViewController+Alert.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import UIKit

extension UIViewController {
    func showAlert(
        title: String,
        message: String,
        buttonTitle: String = AppConstants.Titles.ok
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        present(alert, animated: true)
    }
}
