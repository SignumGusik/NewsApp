//
//  UITableView+Register.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
}
