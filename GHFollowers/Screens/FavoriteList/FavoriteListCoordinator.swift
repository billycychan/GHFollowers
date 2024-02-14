//
//  FavoriteListCoordinator.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 14/2/2024.
//

import UIKit

class FavoriteListCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var rootViewController = UINavigationController()
    
    lazy var viewController: UIViewController = {
        let favoriteListVC = FavoritesListVC()
        favoriteListVC.title = "Favorite"
        favoriteListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return favoriteListVC
    }()
    
    func start() {
        rootViewController.setViewControllers([viewController], animated: false)
    }
}
