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
    
    var rootViewController = UITabBarController()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        children = [mainCoordinator]
        window?.rootViewController = mainCoordinator.rootViewController
    }
    
    func goToMainTab() {
        let searchCoordinator = SearchCoordinator()
        searchCoordinator.start()
        self.children.append(searchCoordinator)
        
        let followerListCoordinator = FollowerListCoordinator()
        followerListCoordinator.start()
        self.children.append(followerListCoordinator)
        
        self.rootViewController.viewControllers = [
            searchCoordinator.rootViewController,
            followerListCoordinator.rootViewController
        ]
    }
}

