//
//  CreateVoteViewController.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class CreateVoteViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let titleTextField = FLTextField(symbolsMaxCount: 60)
    private let descriptionTextField = FLTextField(symbolsMaxCount: 400)
    private let optionsStackView = UIStackView()
    private let addNewOptionButton = UIButton()
    private let createButton = FLButton()
    
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    
    var onDone: VoidClosure?
    var onCancel: VoidClosure?
    
    let viewModel: CreateVoteViewModel
    
    init(viewModel: CreateVoteViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupViews()
        self.setupObservers()
        
        self.updateOptionsView()
        self.viewModel.onUpdateOptions = { [weak self] in
            self?.updateOptionsView()
        }
        
        self.updateViews()
        self.viewModel.onUpdate = { [weak self] in
            self?.updateViews()
        }
    }
    
    private func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelPressed))
        cancelButton.tintColor = UIColor.label
        self.navigationItem.rightBarButtonItem = cancelButton
        self.navigationController?.navigationBar.makeTransparent()
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
                view.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor)
            ]
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "New Vote"
        titleLabel.textColor = .label
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        self.titleTextField.title = "Vote's title"
        self.titleTextField.onDone = { [weak self] in
            self?.titleTextField.resignActive()
            self?.descriptionTextField.becomeActive()
        }
        self.titleTextField.onText = { [weak self] text in
            self?.viewModel.updateTitle(text)
            self?.updateViews()
        }
        
        self.descriptionTextField.title = "Vote's description"
        self.descriptionTextField.onDone = { [weak self] in
            self?.descriptionTextField.resignActive()
        }
        self.descriptionTextField.onText = { [weak self] text in
            self?.viewModel.updateDescription(text.isEmpty ? nil : text)
            self?.updateViews()
        }
        
        let optionsLabel = UILabel()
        optionsLabel.text = "Options"
        optionsLabel.font = .preferredFont(forTextStyle: .headline)
        optionsLabel.textColor = .label
        optionsLabel.textAlignment = .left
        
        self.optionsStackView.axis = .vertical
        self.optionsStackView.spacing = 10
        
        self.addNewOptionButton.setTitle("Add new option", for: .normal)
        self.addNewOptionButton.setTitleColor(UIColor.systemBlue, for: .normal)
        self.addNewOptionButton.addTarget(self, action: #selector(self.addNewOptionPressed), for: .touchUpInside)
        
        self.createButton.setTitle("Create Vote", for: .normal)
        self.createButton.addTarget(self, action: #selector(self.createPressed), for: .touchUpInside)
        self.createButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.createButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 38, bottom: 0, right: 38)
        
        let continueButtonStackView = UIStackView(arrangedSubviews: [UIView(), self.createButton, UIView()])
        continueButtonStackView.axis = .horizontal
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, self.titleTextField, self.descriptionTextField, optionsLabel, self.optionsStackView, self.addNewOptionButton, continueButtonStackView])
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.setCustomSpacing(35, after: titleLabel)
        stackView.setCustomSpacing(7, after: optionsLabel)
        stackView.setCustomSpacing(5, after: self.optionsStackView)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        
        self.scrollView.fl_addSubview(stackView) { (view, container) -> [NSLayoutConstraint] in
            [
                view.topAnchor.constraint(equalTo: container.topAnchor),
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                view.widthAnchor.constraint(equalTo: container.widthAnchor)
            ]
        }
        
        NSLayoutConstraint.activate([
            self.createButton.centerXAnchor.constraint(equalTo: continueButtonStackView.centerXAnchor)
        ])
    }
    
    private func updateOptionsView() {
        self.optionsStackView.subviews.forEach({ $0.removeFromSuperview() })
        
        for option in self.viewModel.options {
            let textField = FLTextField(symbolsMaxCount: 40)
            textField.text = option.name
            textField.isTitleHidden = true
            
            textField.onDone = { [weak textField] in
                textField?.resignActive()
            }
            textField.onText = { [weak self] text in
                self?.viewModel.updateOption(option: option, name: text)
            }
            
            self.optionsStackView.addArrangedSubview(textField)
        }
    }
    
    private func updateViews() {
        self.createButton.isEnabled = self.viewModel.couldCreateVote()
    }
    
    @objc private func createPressed() {
        self.view.endEditing(true)
        
        self.showProgressIndicatorDialog()
        
        self.viewModel.createVote { [weak self] in
            self?.dismissProgressIndicatorDialog()
            self?.onDone?()
        }
    }
    
    @objc private func addNewOptionPressed() {
        self.view.endEditing(true)
        
        self.viewModel.addOption()
    }
    
    @objc private func cancelPressed() {
        self.onCancel?()
    }
}

extension CreateVoteViewController {
    
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
