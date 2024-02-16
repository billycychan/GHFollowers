//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 21/1/2024.
//

import UIKit
import Combine

class FollowerListVC: GFDataLoadingVC {
    private var cancellables = Set<AnyCancellable>()
    
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    weak var coordinator: FollowerListCoordinator?
    private var viewModel: FollowerListViewModel
    
    init(viewModel: FollowerListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
        configureViewController()
        configureCollectionView()
        configureSearchController()
        configureDataSource()
        
        getFollowers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if viewModel.followers.isEmpty && !viewModel.isLoadingMoreFollowers {
            navigationItem.searchController = nil
            var config =  UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "person.slash")
            config.text = "No Followers"
            config.secondaryText = "This user does not have followers. Go follow them."
            contentUnavailableConfiguration = config
        } else if viewModel.isSearching && viewModel.filterFollowers.isEmpty {
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    private func setupBindings() {
        cancellables = [
            viewModel.$followers
                .combineLatest(viewModel.$filterFollowers)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] followers, filterFollowers in
                    guard let self = self else { return }
                    if self.viewModel.isSearching {
                        updateData(on: filterFollowers)
                    } else {
                        updateUI(with: followers)
                    }
                }),
        ]
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdddButton))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func didTapAdddButton() {
        showLoadingView()
        
        Task {
            do {
                try await viewModel.addUserFavorites()
                dismissLoadingView()
                presentGFAlert(title: "Success!", message: "You have successfully favorited this user.", buttonTitle: "Hooray!")
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Something Went Wrong", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
            }
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.delegate = self
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    private func getFollowers() {
        showLoadingView()
        viewModel.isLoadingMoreFollowers = true
        
        Task {
            do {
                try await viewModel.getFollowers()
                dismissLoadingView()
            } catch {
                if let gfError = error as? GFError {
                    self.presentGFAlert(title: "Bad Stuff Happened",
                                        message: gfError.rawValue,
                                        buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                    dismissLoadingView()
                }
            }
            viewModel.isLoadingMoreFollowers = false
        }
    }
    
    private func updateUI(with followers: [Follower]) {
        self.viewModel.hasMoreFollower = followers.count >= 100
        
        if self.viewModel.followers.isEmpty {
            setNeedsUpdateContentUnavailableConfiguration()
            return
        }
        
        self.updateData(on: self.viewModel.followers)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard viewModel.hasMoreFollower, !viewModel.isLoadingMoreFollowers else { return }
            viewModel.page += 1
            getFollowers()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = viewModel.isSearching ? viewModel.filterFollowers : viewModel.followers
        let follower = activeArray[indexPath.item]
        coordinator?.routeToUserInfoVC(username: follower.login)
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchFollowers(with: searchController.searchBar.text ?? "")
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        self.viewModel.username = username
        title = username
        viewModel.page = 1
        
        viewModel.followers.removeAll()
        viewModel.filterFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers()
    }
}
