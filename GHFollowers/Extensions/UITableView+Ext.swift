//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 13/2/2024.
//

import UIKit

extension UITableView {
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }

    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
