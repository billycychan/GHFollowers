//
//  UserInfoViewModel.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 16/2/2024.
//

import Foundation

class UserInfoViewModel {

    @Published var user: User?

    func getUserInfo(for username: String) async throws {
        let user = try await NetworkManager.shared.request(session: .shared, .user(.getUserInfo(username: username)), type: User.self)
        self.user = user
    }
}
