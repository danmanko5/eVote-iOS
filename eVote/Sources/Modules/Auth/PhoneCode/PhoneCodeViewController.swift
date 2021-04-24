//
//  PhoneCodeViewController.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit
import SVProgressHUD
import CBPinEntryView
import AudioToolbox

final class PhoneCodeViewController: UIViewController {
    
    let viewModel: PhoneCodeViewModel
    
    private let titleLabel = UILabel(frame: .zero)
    private let codeEntryView = CBPinEntryView(frame: .zero)
    private let resendButton = UIButton(frame: .zero)
    
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    
    var onCancel: VoidClosure?
   
    init(viewModel: PhoneCodeViewModel) {
        self.viewModel = viewModel
       
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupViews()
        self.setupNavigationBar()
        self.viewModel.isAuthenticating.observe(self) { [weak self] _ in
            self?.updateLoadingState()
        }
        self.updateLoadingState()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.makeTransparent()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.onCancelClicked))
        self.navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    private func setupViews() {
        self.view.backgroundColor = .systemBackground
        
        self.titleLabel.text = "Enter Verification Code"
        self.titleLabel.textColor = .label
        self.titleLabel.font = .preferredFont(forTextStyle: .title1)
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 0
        
        self.codeEntryView.textContentType = .oneTimeCode
        self.codeEntryView.delegate = self
        self.codeEntryView.length = 6
        self.codeEntryView.entryFont = .preferredFont(forTextStyle: .title2)
        self.codeEntryView.entryTextColour = .label
        self.codeEntryView.entryCornerRadius = 10
        self.codeEntryView.entryBackgroundColour = .systemBackground
        self.codeEntryView.entryEditingBackgroundColour = .systemBackground
        self.codeEntryView.entryBorderWidth = 1
        self.codeEntryView.entryBorderColour = UIColor.label
        self.codeEntryView.entryDefaultBorderColour = UIColor.label
        self.codeEntryView.spacing = 10
        
        let codeEntryViewStackView = UIStackView(arrangedSubviews: [UIView(), self.codeEntryView, UIView()])
        codeEntryViewStackView.axis = .horizontal
        codeEntryViewStackView.distribution = .equalCentering
        codeEntryViewStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.resendButton.setTitle("Resend Code", for: .normal)
        self.resendButton.addTarget(self, action: #selector(self.resendButtonPressed), for: .touchUpInside)
        self.resendButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        self.resendButton.setTitleColor(.systemBlue, for: .normal)
        self.resendButton.widthAnchor.constraint(equalToConstant: 135).isActive = true
        
        let resendButtonStackView = UIStackView(arrangedSubviews: [UIView(), self.resendButton, UIView()])
        resendButtonStackView.axis = .horizontal
        resendButtonStackView.distribution = .equalCentering
        resendButtonStackView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, codeEntryViewStackView, resendButtonStackView])
        stackView.axis = .vertical
        stackView.spacing = 44
        stackView.setCustomSpacing(10, after: codeEntryViewStackView)
        
        self.view.fl_addSubview(stackView) { (view, container) -> [NSLayoutConstraint] in
            [
                view.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: 55),
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
            ]
        }
    }
    
    @objc private func onCancelClicked() {
        self.viewModel.cancel()
        self.onCancel?()
    }
    
    private func updateLoadingState() {
        self.viewModel.isAuthenticating.value ? self.showProgressIndicatorDialog() : self.dismissProgressIndicatorDialog()
    }
    
    
    @objc private func resendButtonPressed() {
        self.viewModel.resentCode { _ in }
    }
    
}

extension PhoneCodeViewController: CBPinEntryViewDelegate {
    func entryChanged(_ completed: Bool) {
    }
    
    func entryCompleted(with entry: String?) {
        guard let code = entry, !code.isEmpty  else { return }
        
        self.viewModel.confirmAuthentication(with: code) { [weak self] (success) in
            if success {
                self?.view.endEditing(true)
            } else {
                self?.codeEntryView.clearEntry()
                AudioServicesPlaySystemSound(SystemSoundID(1002))
            }
        }
    }
}

