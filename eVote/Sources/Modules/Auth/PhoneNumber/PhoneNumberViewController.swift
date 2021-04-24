//
//  PhoneNumberViewController.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class PhoneNumberViewController: UIViewController {
    
    private static let defaultSatusText = "We’ll send you a text with verification code"
    
    var onDone: StringClosure?
    var onCountry: VoidClosure?
    
    let viewModel: PhoneNumberViewModel
    
    private let titleLabel = UILabel(frame: .zero)
    private let statusLabel = UILabel(frame: .zero)
    private let countryCodeButton = UIButton(frame: .zero)
    private let phoneTextField = TextFieldWithInsets(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    private let continueButton = FLButton()
    private let activityIndicatorView = UIActivityIndicatorView(frame: .zero)
    
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    
    init(viewModel: PhoneNumberViewModel) {
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
        self.setupViewModel()
        self.updateLoadingState()
    }

    private func setupNavigationBar() {
        self.navigationController?.navigationBar.makeTransparent()
    }
    
    private func setupViews() {
        self.activityIndicatorView.color = self.view.tintColor
        self.view.backgroundColor = .systemBackground
        
        self.titleLabel.text = "Enter your mobile number"
        self.titleLabel.textColor = .label
        self.titleLabel.font = .preferredFont(forTextStyle: .title1)
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 0
        
        self.statusLabel.font = .preferredFont(forTextStyle: .caption2)
        self.statusLabel.textAlignment = .center
        self.statusLabel.numberOfLines = 0
        self.updateStatusLabel(text: PhoneNumberViewController.defaultSatusText, isError: false)
        
        self.countryCodeButton.addTarget(self, action: #selector(self.selectCountryCode), for: .touchUpInside)
        self.countryCodeButton.setTitleColor(.label, for: .normal)
        self.countryCodeButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.countryCodeButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.countryCodeButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        self.countryCodeButton.layer.cornerRadius = 10
        self.countryCodeButton.layer.borderWidth = 1
        self.countryCodeButton.layer.borderColor = UIColor.label.cgColor
        self.countryCodeButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.updateCountryButton()
        
        self.phoneTextField.keyboardType = .phonePad
        self.phoneTextField.delegate = self
        self.phoneTextField.font = .preferredFont(forTextStyle: .body)
        self.phoneTextField.textColor = .label
        self.phoneTextField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.phoneTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.phoneTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 125).isActive = true
        self.phoneTextField.layer.cornerRadius = 10
        self.phoneTextField.layer.borderWidth = 1
        self.phoneTextField.layer.borderColor = UIColor.label.cgColor
        self.phoneTextField.becomeFirstResponder()
        
        let phoneNumberStackView = UIStackView(arrangedSubviews: [self.countryCodeButton, self.phoneTextField])
        phoneNumberStackView.axis = .horizontal
        phoneNumberStackView.distribution = .fill
        phoneNumberStackView.spacing = 10
        phoneNumberStackView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [phoneNumberStackView,  self.statusLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        
        self.continueButton.setTitle("Continue", for: .normal)
        self.continueButton.addTarget(self, action: #selector(self.sendButtonPressed), for: .touchUpInside)
        self.continueButton.isEnabled = false
        
        self.view.fl_addSubview(self.titleLabel) { (view, container) -> [NSLayoutConstraint] in
            [
                view.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: 45),
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
            ]
        }
        
        self.view.fl_addSubview(stackView) { (view, container) -> [NSLayoutConstraint] in
            [
                view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                view.widthAnchor.constraint(lessThanOrEqualTo: container.widthAnchor, constant: -32)
            ]
        }
        
        self.view.fl_addSubview(self.statusLabel) { (view, container) -> [NSLayoutConstraint] in
            [
                view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
            ]
        }
        
        self.view.fl_addSubview(self.continueButton) { (view, container) -> [NSLayoutConstraint] in
            [
                view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                view.heightAnchor.constraint(equalToConstant: 44),
                view.widthAnchor.constraint(equalToConstant: 169)
            ]
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 55),
            self.continueButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 47),
            self.statusLabel.widthAnchor.constraint(lessThanOrEqualTo: phoneNumberStackView.widthAnchor, multiplier: 1.0)
        ])
        
        self.view.fl_addSubview(self.activityIndicatorView, layoutConstraints: UIView.fl_constraintsCenter)
    }
    
    @objc private func onCancelClicked() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        self.viewModel.cancel()
    }
    
    private func setupViewModel() {
        
        self.viewModel.isAuthenticating.observe(self) { [weak self] _ in
            self?.updateLoadingState()
        }
        self.viewModel.countryUpdatedCallback = { [weak self] in
            self?.updateCountryButton()
        }
    }
    
    private func updateLoadingState() {
        self.viewModel.isAuthenticating.value ? self.showProgressIndicatorDialog() : self.dismissProgressIndicatorDialog()
    }
    
    private func updateCountryButton() {
        let title = self.viewModel.countryCodeTitle()
        self.countryCodeButton.setTitle(title, for: .normal)
    }
    
    @objc private func selectCountryCode() {
        self.onCountry?()
    }
    
    @objc private func sendButtonPressed() {
        guard let phone = self.phoneTextField.text, !phone.isEmpty else { return }

        let number = self.viewModel.displayableNumber(phone)
        self.viewModel.authenticate(phoneNumber: number) { [weak self] (result) in
            switch result{
            case .failure(let error):
                self?.updateStatusLabel(text: error.localizedDescription, isError: true)
            case .success():
                self?.onDone?(number)
                self?.updateStatusLabel(text: PhoneNumberViewController.defaultSatusText, isError: false)
            }
        }
    }
    
    private func updateStatusLabel(text: String, isError: Bool) {
        self.statusLabel.text = text
        self.statusLabel.textColor = isError ? .systemRed : .label
    }
}

extension PhoneNumberViewController: CountriesViewControllerDelegate {
    func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
    }
    
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        self.viewModel.updateCountry(country)
    }
}

extension PhoneNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            let isValid = self.viewModel.validateNumber(updatedText)
            self.continueButton.isEnabled = isValid
        }
        return true
    }
}
