//
//  AppFlowCoordinator.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

protocol AppFlowUIFactory {
    func makeRootViewController() -> UIViewController
}

protocol AppChildFlowCoordinatorsProvider {
    func makeHomeFlowCoordinator(user: User) -> HomeFlowCoordinator
    func makeAuthFlowCoordinator() -> AuthFlowCoordinator
    func makeProfileSetupFlowCoordinator(userId: Identifier) -> ProfileSetupFlowCoordinator
}

final class AppFlowCoordinator: FlowCoordinator {
    
    let uiFactory: AppFlowUIFactory
    let flowCoordinatorsProvider: AppChildFlowCoordinatorsProvider
    let authenticationStateProvider: AuthenticationStateProvider
    
    let rootViewController: UIViewController
    var childFlowCoordinators: [FlowCoordinator]
    
    init(uiFactory: AppFlowUIFactory,
         flowCoordinatorsProvider: AppChildFlowCoordinatorsProvider,
         authenticationStateProvider: AuthenticationStateProvider) {
        
        self.uiFactory = uiFactory
        self.flowCoordinatorsProvider = flowCoordinatorsProvider
        self.authenticationStateProvider = authenticationStateProvider
        
        self.rootViewController = uiFactory.makeRootViewController()
        self.childFlowCoordinators = []
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
        case .retrieving:
            break
        case .notAuthenticated:
            self.removeChildFlowCoordinators()
            self.showAuthFlow()
        case .authenticatedUncomplete(let userId):
            self.removeChildFlowCoordinators()
            self.showProfileSetupFlow(userId: userId)
        case .authenticated(let user):
            self.removeChildFlowCoordinators()
            self.showHomeFlow(user: user)
        }
    }

    private func removeChildFlowCoordinators() {
        self.childFlowCoordinators.forEach {
            $0.rootViewController.dismiss(animated: false, completion: nil)
            $0.rootViewController.fl_unembedSelf()
        }
        self.childFlowCoordinators = []
    }
    
    private func showProfileSetupFlow(userId: Identifier) {
        let profileSetupFlowCoordinator = self.flowCoordinatorsProvider.makeProfileSetupFlowCoordinator(userId: userId)
        profileSetupFlowCoordinator.onDone = { [weak self] user in
            self?.showHomeFlow(user: user)
        }
        
        self.rootViewController.fl_embed(viewController: profileSetupFlowCoordinator.rootViewController)
        self.addChildFlowCoordinator(profileSetupFlowCoordinator)
    }
    
    private func showAuthFlow() {
        let authFlowCoordinator = self.flowCoordinatorsProvider.makeAuthFlowCoordinator()
        authFlowCoordinator.onDone = { [weak self] userId in
            self?.showProfileSetupFlow(userId: userId)
        }
        authFlowCoordinator.onLoggedIn = { [weak self] user in
            self?.showHomeFlow(user: user)
        }
        
        self.rootViewController.fl_embed(viewController: authFlowCoordinator.rootViewController)
        self.addChildFlowCoordinator(authFlowCoordinator)
    }
    
    private func showHomeFlow(user: User) {
        let homeFlowCoordinator = self.flowCoordinatorsProvider.makeHomeFlowCoordinator(user: user)
        
        self.rootViewController.fl_embed(viewController: homeFlowCoordinator.rootViewController)
        self.addChildFlowCoordinator(homeFlowCoordinator)
    }
}
