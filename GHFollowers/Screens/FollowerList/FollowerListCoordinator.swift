//
//  FollowerListCoordinator.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 14/2/2024.
//

import UIKit

class FollowerListCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var rootViewController = UINavigationController()
    
    lazy var viewController: UIViewController = {
        let followerListVC = FollowerListVC(username: "")
        followerListVC.username = ""
        followerListVC.title = "Favorite"
        followerListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return followerListVC
    }()
    
    func start() {
        rootViewController.setViewControllers([viewController], animated: false)
    }
}
