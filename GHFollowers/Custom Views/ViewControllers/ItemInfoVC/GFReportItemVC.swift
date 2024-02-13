//
//  GFReportItemVC.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 1/2/2024.
//

import Foundation

protocol GFReportItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

class GFReportItemVC: GFItemInfoVC {
    
    weak var delegate: GFReportItemVCDelegate?
    
    init(user: User, delegate: GFReportItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
