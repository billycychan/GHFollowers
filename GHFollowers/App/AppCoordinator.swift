//
//  AppCoordinator.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 14/2/2024.
//

import UIKit

class AppCoordinator: Coordinator {
    let window: UIWindow?

    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        children = [mainCoordinator]
        window?.rootViewController = mainCoordinator.rootViewController
    }
}
