//
//  UserInfoCoordinator.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 16/2/2024.
//

import UIKit

class UserInfoCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    
    var rootViewController: UIViewController

    lazy var viewController: UserInfoVC = {
        let viewModel = UserInfoViewModel()
        let userInfoVC = UserInfoVC(viewModel: viewModel)
        return userInfoVC
    }()
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        viewController.coordinator = self
        
        let navController = UINavigationController()
        navController.setViewControllers([viewController], animated: false)
        rootViewController.present(navController, animated: true)
    }
    
    func dismiss() {
        viewController.dismiss(animated: true) { [weak self] in
            self?.parentCoordinator?.children.removeAll { $0 is UserInfoCoordinator }
        }
    }
}
