//
//  ProfileSetupUIFactory.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

protocol ProfileSetupFlowUIFactory {
    func makeProfileSetupViewController(userId: Identifier) -> ProfileSetupViewController
    func makeNavigationController(with rootViewController: UIViewController) -> UINavigationController
}

final class ProfileSetupUIFactory: ProfileSetupFlowUIFactory {

    let viewModelsFactory: ProfileSetupViewModelsFactory
    
    init(viewModelsFactory: ProfileSetupViewModelsFactory) {
        self.viewModelsFactory = viewModelsFactory
    }
    
    func makeNavigationController(with rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        return navigationController
    }
    
    func makeProfileSetupViewController(userId: Identifier) -> ProfileSetupViewController {
        let viewModel = self.viewModelsFactory.makeProfileSetupViewModel(userId: userId)
        let viewController = ProfileSetupViewController(viewModel: viewModel)
        
        return viewController
    }
}
