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
    
    lazy var viewController: UserInfoVC = {
        let viewModel = UserInfoViewModel()
        let userInfoVC = UserInfoVC(viewModel: viewModel)
        return userInfoVC
    }()
    
    func start() {
        viewController.coordinator = self
    }
    
    func dismiss() {
        viewController.dismiss(animated: true) { [weak self] in
            self?.parentCoordinator?.children.removeAll { $0 is UserInfoCoordinator }
        }
    }
}
