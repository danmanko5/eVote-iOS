//
//  AuthFlowCoordinator.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class AuthFlowCoordinator: FlowCoordinator {
    
    let uiFactory: AuthFlowUIFactory
    
    let rootViewController: UIViewController
    var childFlowCoordinators: [FlowCoordinator]
    
    let authenticationStateProvider: AuthenticationStateProvider
    
    var onDone: StringClosure?
    var onLoggedIn: UserClosure?
    
    init(uiFactory: AuthFlowUIFactory,
         authenticationStateProvider: AuthenticationStateProvider) {
        self.uiFactory = uiFactory
        self.authenticationStateProvider = authenticationStateProvider
        
        let phoneNumberViewController = uiFactory.makePhoneNumberViewController()
        
        self.rootViewController = uiFactory.makeNavigationController(with: phoneNumberViewController)
        self.childFlowCoordinators = []
        
        phoneNumberViewController.onDone = { [weak self, weak rootViewController] number in
            guard let sself = self, let vc = rootViewController else { return }
            
            sself.showPhoneCodeViewController(from: vc)
        }
        
        phoneNumberViewController.onCountry = { [weak self, weak phoneNumberViewController] in
            guard let phoneNumberViewController = phoneNumberViewController else { return }
            self?.showCountriesViewController(phoneNumberViewController: phoneNumberViewController)
        }
    }
    
    func install() {
        self.authenticationStateProvider.authenticationState.observe(self) { [weak self] _ in
            self?.updateForCurrentAuthenticationState()
        }
        self.updateForCurrentAuthenticationState()
    }
    
    private func updateForCurrentAuthenticationState() {
        let state = self.authenticationStateProvider.authenticationState.value
        
        switch state {
        case .notAuthenticated, .retrieving:
            break
        case .authenticatedUncomplete(let userId):
            self.onDone?(userId)
        case .authenticated(let user):
            self.onLoggedIn?(user)
        }
    }
    
    private func showPhoneCodeViewController(from sender: UIViewController) {
        let viewController = self.uiFactory.makePhoneCodeViewController()
        
        sender.show(viewController, sender: nil)
    }
    
    private func showCountriesViewController(phoneNumberViewController: PhoneNumberViewController) {
        let countriesViewController = self.uiFactory.makeCountriesViewController()
        countriesViewController.delegate = phoneNumberViewController
        let navigationController = UINavigationController(rootViewController: countriesViewController)
        self.rootViewController.present(navigationController, animated: true, completion: nil)
    }
    
    
    private func showError(from sender: UIViewController, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
}
