//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 20/1/2024.
//

import UIKit
import Combine

class FavoritesListVC: GFDataLoadingVC {
    private var cancellables = Set<AnyCancellable>()
    
    lazy private(set) var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        return tableView
    }()
    
    weak var coordinator: FavoriteListCoordinator?
    private var viewModel: FavoriteListViewModel
    
    init(viewModel: FavoriteListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if viewModel.favorites.isEmpty {
            var config =  UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "star")
            config.text = "No Favorites"
            config.secondaryText = "Add a favorite on the follower list screen"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    private func setupBindings() {
        cancellables =  [
            viewModel.$favorites
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self]  in
                    self?.updateUI(with: $0)
                })
        ]
    }
    
    func getFavorites() {
        Task {
            do {
                try await viewModel.retrieveFavorites()
            } catch {
                if let gfError = error as? GFError {
                    DispatchQueue.main.async {
                        self.presentGFAlert(title: "Something went wrong", message: gfError.rawValue, buttonTitle: "Ok")
                    }
                }
            }
        }
    }
    
    func updateUI(with favorites: [Follower]) {
        setNeedsUpdateContentUnavailableConfiguration()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = viewModel.favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = viewModel.favorites[indexPath.row]
        coordinator?.routeToFollowerListVC(username: favorite.login)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let favorite = viewModel.favorites[indexPath.row]
        Task {
            do {
                try await viewModel.remove(favorite: favorite)
                self.viewModel.favorites.remove(at : indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                setNeedsUpdateContentUnavailableConfiguration()
                
            } catch {
                if let gfError = error as? GFError {
                    DispatchQueue.main.async {
                        self.presentGFAlert(title: "Unable to remove", message: gfError.rawValue, buttonTitle: "Ok")
                    }
                }
            }
        }
    }
}
