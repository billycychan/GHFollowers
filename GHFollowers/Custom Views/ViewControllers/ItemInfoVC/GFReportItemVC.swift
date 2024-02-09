//
//  GFReportItemVC.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 1/2/2024.
//

import Foundation

class GFReportItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButonnTapped() {
        delegate?.didTapGitHubProfile(for: user)
    }
}
