//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 20/1/2024.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {
    let tableView = UITableView()
    var favorites: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if favorites.isEmpty {
            var config =  UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "star")
            config.text = "No Favorites"
            config.secondaryText = "Add a favorite on the follower list screen"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    func getFavorites() {
        Task {
            do {
               let favorites = try await PersistenceManager.retrieveFavorites()
                self.updateUI(with: favorites)
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
        self.favorites = favorites
        setNeedsUpdateContentUnavailableConfiguration()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListVC(username: favorite.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let favorite = favorites[indexPath.row]
        Task {
            do {
                try await PersistenceManager.updateWith(favorite: favorite, actionType: .remove)
                self.favorites.remove(at : indexPath.row)
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
