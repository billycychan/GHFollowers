//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 30/1/2024.
//

import UIKit
import SafariServices
import Combine

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
    private var cancellables = Set<AnyCancellable>()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    var username: String!
    
    weak var coordinator: UserInfoCoordinator?
    weak var delegate: UserInfoVCDelegate?
    private let viewModel: UserInfoViewModel
    
    init(viewModel: UserInfoViewModel) {
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
        configureScrollView()
        layoutUI()
        
        getUserInfo()
        
    }
    
    func setupBindings() {
        cancellables = [
            viewModel.$user
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] user in
                    guard let self, let user else { return }
                    self.configureUIElements(with: user)
                })
        ]
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600),
        ])
        
    }
    
    func getUserInfo() {
        Task {
            do {
                try await viewModel.getUserInfo(for: username)
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Something Went Wrong", message: gfError.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }
    
    func configureUIElements(with user: User) {
        self.add(childVC: GFReportItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.dateLabel.text = "GithHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func didTapDoneButton() {
        coordinator?.dismiss()
    }
}

extension UserInfoVC: GFReportItemVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlert(
                title: "Invalid URL",
                message: "The url attached to this user is invalid",
                buttonTitle: "Ok"
            )
            return
        }
        
        presentSafariVC(with: url)
    }
}

extension UserInfoVC: GFFollowerItemVCDelegate {
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlert(
                title: "No Followers",
                message: "This user has no followers. What a shame 😳.",
                buttonTitle: "So sad"
            )
            return
        }
        
        delegate?.didRequestFollowers(for: user.login)
        coordinator?.dismiss()
    }
}
