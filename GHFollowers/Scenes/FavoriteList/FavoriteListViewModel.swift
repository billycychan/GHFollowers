//
//  FavoriteListViewModel.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 15/2/2024.
//

import Foundation

class FavoriteListViewModel {
   @Published var favorites: [Follower] = []

    init() {}

    func retrieveFavorites() async throws {
        Task {
            let favroites = try await PersistenceManager.retrieveFavorites()
            self.favorites = favroites
        }
    }

    func remove(favorite: Follower) async throws {
        try await PersistenceManager.updateWith(favorite: favorite, actionType: .remove)
    }
}
