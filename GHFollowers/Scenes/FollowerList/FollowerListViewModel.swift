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

    var activeArray: [Follower] {
        isSearching ? filterFollowers : followers
    }

    var isSearching = false
    var hasMoreFollower: Bool {
        followers.count >= 100
    }
    var isLoadingMoreFollowers = false

    var username: String
    var page = 1

    init(username: String, page: Int = 1) {
        self.username = username
        self.page = page
    }

    func getFollowers() async throws {
        let followers = try await NetworkManager.shared.request(session: .shared, .user(.getfollowers(username: username, page: page)), type: [Follower].self)
        self.followers.append(contentsOf: followers)
    }

    func searchFollowers(with filter: String) {
        guard isSearching else {
            filterFollowers.removeAll()
            isSearching = false
            return
        }
        filterFollowers = followers.filter {$0.login.lowercased().contains(filter.lowercased())}
    }

    func addUserFavorites() async throws {
        let user = try await NetworkManager.shared.request(session: .shared, .user(.getUserInfo(username: username)), type: User.self)
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        try await PersistenceManager.updateWith(favorite: favorite, actionType: .add)
    }

    func reset() {
        page = 1
        followers.removeAll()
        filterFollowers.removeAll()
        isSearching = false
    }
}
