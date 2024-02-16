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
    
    var navigationController: UINavigationController
    
    private let username: String
    
    init(username: String, navigationController: UINavigationController) {
        self.username = username
        self.navigationController = navigationController
    }
    
    lazy var viewController: FollowerListVC = {
        let viewModel = FollowerListViewModel(username: username)
        let followerListVC = FollowerListVC(viewModel: viewModel)
        followerListVC.title = username
        return followerListVC
    }()
    
    func start() {
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToUserInfoVC(username: String) {
        let userInfoCoordinator = UserInfoCoordinator()
        userInfoCoordinator.start()
        userInfoCoordinator.parentCoordinator = self
        children = [userInfoCoordinator]
        
        userInfoCoordinator.viewController.username = username
        userInfoCoordinator.viewController.delegate = viewController
        
        let navController = UINavigationController()
        navController.setViewControllers([userInfoCoordinator.viewController], animated: true)
        viewController.present(navController, animated: true)
    }
}
