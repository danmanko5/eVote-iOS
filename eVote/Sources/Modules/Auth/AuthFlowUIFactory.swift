//
//  AuthFlowUIFactory.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

protocol AuthFlowUIFactory {
    func makePhoneNumberViewController() -> PhoneNumberViewController
    func makePhoneCodeViewController() -> PhoneCodeViewController
    func makeCountriesViewController() -> CountriesViewController
    func makeNavigationController(with rootViewController: UIViewController) -> UINavigationController
}

final class AuthUIFactory: AuthFlowUIFactory {

    let viewModelsFactory: AuthViewModelsFactory
    
    init(viewModelsFactory: AuthViewModelsFactory) {
        self.viewModelsFactory = viewModelsFactory
    }
    
    func makeNavigationController(with rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        return navigationController
    }
    
    func makePhoneNumberViewController() -> PhoneNumberViewController {
        let viewModel = self.viewModelsFactory.makePhoneNumberViewModel()
        let viewController = PhoneNumberViewController(viewModel: viewModel)
        
        return viewController
    }
    
    func makePhoneCodeViewController() -> PhoneCodeViewController {
        let viewModel = self.viewModelsFactory.makePhoneCodeViewModel()
        let viewController = PhoneCodeViewController(viewModel: viewModel)
        
        return viewController
    }
    
    func makeCountriesViewController() -> CountriesViewController {
        let viewController = CountriesViewController.standardController()
        return viewController
    }
}
