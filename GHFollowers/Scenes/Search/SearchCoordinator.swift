//
//  SearchCoordinator.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 14/2/2024.
//

import UIKit

class SearchCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?

    var children: [Coordinator] = []

    var rootViewController = UINavigationController()

    lazy var viewController: SearchVC = {
        let viewModel = SearchViewModel()
        let searchVC = SearchVC(viewModel: viewModel)
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return searchVC
    }()

    func start() {
        viewController.coordinator = self
        rootViewController.setViewControllers([viewController], animated: false)
    }
}

extension SearchCoordinator {
    func routeToFollowerListVC(username: String) {
        let followerListCoordinator = FollowerListCoordinator(username: username,
                                                              navigationController: rootViewController)
        followerListCoordinator.parentCoordinator = self
        children = [followerListCoordinator]
        followerListCoordinator.start()
    }
}
