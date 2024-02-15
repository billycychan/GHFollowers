//
//  FollowerListViewModel.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 15/2/2024.
//

import Foundation

class FollowerListViewModel {
    @Published var followers: [Follower] = []
    @Published var filterFollowers: [Follower] = []
    @Published var isSearching = false
    
    var hasMoreFollower = true
    var isLoadingMoreFollowers = false
    
    var username: String
    var page = 1
    
    init(username: String, page: Int = 1) {
        self.username = username
        self.page = page
    }

    func getFollowers() async throws  {
        let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
        self.followers.append(contentsOf: followers)
    }

    func searchFollowers(with filter: String) {
        guard !filter.isEmpty else {
            filterFollowers.removeAll()
            isSearching = false
            return
        }
        isSearching = true
        filterFollowers = followers.filter {$0.login.lowercased().contains(filter.lowercased())}
    }
    
    func addUserFavorites() async throws {
        let user = try await NetworkManager.shared.getUserInfo(for: username)
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        try await PersistenceManager.updateWith(favorite: favorite, actionType: .add)
    }
}
