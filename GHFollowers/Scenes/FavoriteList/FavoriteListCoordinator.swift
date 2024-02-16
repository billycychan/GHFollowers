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
        let viewModel = FavoriteListViewModel()
        let favoriteListVC = FavoritesListVC(viewModel: viewModel)
        favoriteListVC.title = "Favorite"
        favoriteListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        favoriteListVC.coordinator = self
        return favoriteListVC
    }()
    
    func start() {
        rootViewController.setViewControllers([viewController], animated: false)
    }
    
    func routeToFollowerListVC(username: String) {
        let followerListCoordinator = FollowerListCoordinator(username: username, navigationController: rootViewController)
        followerListCoordinator.start()
        followerListCoordinator.parentCoordinator = self
        children = [followerListCoordinator]
    }
}
