//
//  ProfileSetupViewController.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class ProfileSetupViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let usernameTextField = FLTextField(symbolsMaxCount: 40)
    private let continueButton = FLButton()
    
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    
    let viewModel: ProfileSetupViewModel
    
    var onError: StringClosure?
    var onDone: OptionalUserClosure?
    
    init(viewModel: ProfileSetupViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.onUpdate = { [weak self] in
            self?.updateViews()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupObservers()
        
        self.setupViews()
        self.updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupViews() {
        self.view.backgroundColor = .systemBackground
        
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.preservesSuperviewLayoutMargins = true
        self.scrollView.showsVerticalScrollIndicator = false
        
        self.view.fl_addSubview(self.scrollView) { (view, container) -> [NSLayoutConstraint] in
            let constraint = view.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor)
            self.scrollViewBottomConstraint = constraint
            return [
                constraint,
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                view.topAnchor.constraint(equalTo: container.topAnchor)
            ]
        }
        
        self.usernameTextField.title = "Username"
        self.usernameTextField.onDone = { [weak self] in
            self?.usernameTextField.resignActive()
            self?.continuePressed()
        }
        self.usernameTextField.onText = { [weak self] username in
            self?.viewModel.updateUsername(username)
            self?.continueButton.isEnabled = self?.viewModel.couldUpdateUser() ?? false
        }
        
        self.continueButton.setTitle("Continue", for: .normal)
        self.continueButton.addTarget(self, action: #selector(self.continuePressed), for: .touchUpInside)
        self.continueButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.continueButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 38, bottom: 0, right: 38)
        
        let continueButtonStackView = UIStackView(arrangedSubviews: [UIView(), self.continueButton, UIView()])
        continueButtonStackView.axis = .horizontal
        
        let stackView = UIStackView(arrangedSubviews: [self.usernameTextField, continueButtonStackView])
        stackView.axis = .vertical
        stackView.spacing = 50
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 60, left: 20, bottom: 30, right: 20)
        
        self.scrollView.fl_addSubview(stackView) { (view, container) -> [NSLayoutConstraint] in
            [
                view.topAnchor.constraint(equalTo: container.topAnchor),
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                view.widthAnchor.constraint(equalTo: container.widthAnchor)
            ]
        }
        
        NSLayoutConstraint.activate([
            self.continueButton.centerXAnchor.constraint(equalTo: continueButtonStackView.centerXAnchor)
        ])
    }
    
    private func  updateViews() {
        self.continueButton.isEnabled = self.viewModel.couldUpdateUser()
    }
    
    @objc private func continuePressed() {
        self.view.endEditing(true)
        
        self.showProgressIndicatorDialog()
        
        self.viewModel.updateUser { [weak self] (user) in
            self?.dismissProgressIndicatorDialog()
            self?.onDone?(user)
        }
    }
}

extension ProfileSetupViewController {
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 2) { [weak self] in
                self?.scrollViewBottomConstraint?.constant = -keyboardHeight + (self?.view.safeAreaInsets.bottom ?? 0)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 2) { [weak self] in
            self?.scrollViewBottomConstraint?.constant = 0
        }
    }
}
