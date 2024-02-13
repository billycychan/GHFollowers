//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 1/2/2024.
//

import Foundation

protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)

}
class GFFollowerItemVC: GFItemInfoVC {
    weak var delegate: GFFollowerItemVCDelegate?
    
    init(user: User, delegate: GFFollowerItemVCDelegate) {
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
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButonnTapped() {
        delegate?.didTapGetFollowers(for: user)
    }
}
