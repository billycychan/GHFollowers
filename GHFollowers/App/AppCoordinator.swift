//
//  AppCoordinator.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 14/2/2024.
//

import UIKit

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToMainTab()
    }
    
    func goToMainTab() {
        let tabBarController = GFTabBarController()
        navigationController.pushViewController(tabBarController, animated: true)
    }
}

