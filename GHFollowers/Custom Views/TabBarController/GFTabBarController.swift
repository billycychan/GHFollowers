//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 12/2/2024.
//

import UIKit

class GFTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [createSearchNavigationController(), createFavoritesNavigationController()]
        UITabBar.appearance().tintColor = .systemGreen
    }
    
    
    func createSearchNavigationController() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNavigationController() -> UINavigationController {
        let favoriteListVC = FavoritesListVC()
        favoriteListVC.title = "Favorite"
        favoriteListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoriteListVC)
    }
}
