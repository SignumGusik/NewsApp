//
//  NSLayoutConstraint+Helpers.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import UIKit

extension NSLayoutConstraint {
    static func activate(_ constraints: [NSLayoutConstraint]...) {
        NSLayoutConstraint.activate(constraints.flatMap { $0 })
    }
}
