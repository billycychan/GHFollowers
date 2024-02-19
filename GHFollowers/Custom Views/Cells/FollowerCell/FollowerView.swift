//
//  FollowerView.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 13/2/2024.
//

import SwiftUI

struct FollowerView: View {

    private var avatarUrl: String
    private var username: String

    @State private var image: UIImage?

    init(avatarUrl: String, username: String) {
        self.avatarUrl = avatarUrl
        self.username = username
    }

    var body: some View {
        VStack {
            Image(uiImage: image ?? Images.placeholder)
                .resizable()
                .frame(width: 100, height: 100)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())

            Text(username)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .task {
            self.image = await NetworkManager.shared.downloadImage(from: avatarUrl)
        }
    }
}
