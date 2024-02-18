//
//  MainCoordinator.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 14/2/2024.
//

import UIKit

class MainCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?

    var children: [Coordinator] = []

    var rootViewController: UITabBarController

    init() {
        self.rootViewController = UITabBarController()
        UITabBar.appearance().tintColor = .systemGreen
        configureNavigationBar()
        configureTabBar()
    }

    func start() {
        let searchCoordinator = SearchCoordinator()
        searchCoordinator.start()
        children.append(searchCoordinator)

        let favoriteListCoordinator = FavoriteListCoordinator()
        favoriteListCoordinator.start()
        children.append(favoriteListCoordinator)

        let firstViewController = searchCoordinator.rootViewController
        let secondViewController = favoriteListCoordinator.rootViewController

        rootViewController.viewControllers = [firstViewController, secondViewController]
    }

    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemGreen
    }

    func configureTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
