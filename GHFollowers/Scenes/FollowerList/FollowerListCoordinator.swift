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
    
    lazy var viewController: UIViewController = {
        let followerListVC = FollowerListVC(username: username)
        return followerListVC
    }()
    
    func start() {
        navigationController.pushViewController(viewController, animated: true)
    }
}
