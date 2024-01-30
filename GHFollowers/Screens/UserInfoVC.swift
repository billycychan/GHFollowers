//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 30/1/2024.
//

import UIKit

class UserInfoVC: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                self.presentGFAlertOnMainThread(
                    title: "Something went wrong",
                    message: error.rawValue,
                    buttonTitle: "Ok"
                )
            }
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
