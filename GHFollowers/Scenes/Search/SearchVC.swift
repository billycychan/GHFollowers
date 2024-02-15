//
//  SearchVC.swift
//  GHFollowers
//
//  Created by CHI YU CHAN on 20/1/2024.
//

import UIKit
import Combine

class SearchVC: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    lazy private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.ghLogo
        return imageView
    }()

    lazy private var usernameTextField: GFTextField = {
       return GFTextField()
    }()
    
    lazy private var callToActionButton: GFButton = {
        GFButton(
            color: .systemGreen,
            title: "Get Followers",
            systemImageName: "person.3"
        )
    }()

    weak var coordinator: SearchCoordinator?
    private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, usernameTextField, callToActionButton)
        
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
        
        setupBindings()
        
        NSLayoutConstraint.activate([
            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.username = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupBindings() {
        cancellables = [
            usernameTextField.textPublisher.sink { [weak self] text in
                self?.viewModel.username = text
            },
            viewModel.$username.sink { [weak self] username in self?.usernameTextField.text = username }
        ]
    }
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func didTapCallToActionButton() {
        guard !viewModel.username.isEmpty else {
            presentGFAlert(
                title: "Empty Username",
                message: "Please enter a username. We need to know who to look for😀",
                buttonTitle: "Ok"
            )
            return
        }
        
        usernameTextField.resignFirstResponder()
        coordinator?.routeToFollowerListVC(username: viewModel.username)
    }
    
    private func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureTextField() {
        usernameTextField.delegate = self
        usernameTextField.spellCheckingType = .no
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureCallToActionButton() {
        callToActionButton.addTarget(self, action: #selector(didTapCallToActionButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapCallToActionButton()
        return true
    }
}

#Preview {
    SearchVC(viewModel: SearchViewModel())
}
