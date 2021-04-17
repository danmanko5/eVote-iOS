//
//  ProfileSetupFlowCoordinator.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class ProfileSetupFlowCoordinator: FlowCoordinator {
    
    let uiFactory: ProfileSetupUIFactory
    
    let rootViewController: UIViewController
    var childFlowCoordinators: [FlowCoordinator]
    
    var onDone: UserClosure?
    
    let userId: Identifier
    
    init(uiFactory: ProfileSetupUIFactory, userId: Identifier) {
        self.uiFactory = uiFactory
        self.userId = userId
        
        let profileSetupViewController = uiFactory.makeProfileSetupViewController(userId: userId)
        
        self.rootViewController = uiFactory.makeNavigationController(with: profileSetupViewController)
        self.childFlowCoordinators = []
        
        profileSetupViewController.onDone = { [weak self] user in
            guard let user = user else { return }
            self?.onDone?(user)
        }
        
        profileSetupViewController.onError = { [weak self, weak profileSetupViewController] message in
            guard let sself = self, let vc = profileSetupViewController else { return }
            sself.showError(from: vc, message: message)
        }
    }
    
    func install() {
    }
  
    private func showError(from sender: UIViewController, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
}
