//
//  HomeFlowUIFactory.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

protocol HomeFlowUIFactory {
    func makeRootViewController() -> UITabBarController
    func makeNavigationController(with rootViewController: UIViewController) -> UINavigationController
    func makeSettingsViewController(user: User) -> SettingsViewController
    func makeMyVotesViewController(user: User) -> MyVotesViewController
    func makeHomeViewController() -> HomeViewController
    func makeCreateVoteViewController(user: User) -> CreateVoteViewController
    func makeVoteViewController(vote: Vote) -> VoteViewController
    func makeVoteResultViewController(vote: Vote) -> VoteResultViewController
}

final class HomeUIFactory: HomeFlowUIFactory {

    let viewModelsFactory: HomeViewModelsFactory
    
    init(viewModelsFactory: HomeViewModelsFactory) {
        self.viewModelsFactory = viewModelsFactory
    }
    
    func makeRootViewController() -> UITabBarController {
        let viewController = UITabBarController(nibName: nil, bundle: nil)
        return viewController
    }
    
    func makeNavigationController(with rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        return navigationController
    }
    
    func makeSettingsViewController(user: User) -> SettingsViewController {
        let viewModel = self.viewModelsFactory.makeSettingsViewModel(user: user)
        let viewController = SettingsViewController(viewModel: viewModel)
        
        return viewController
    }
    
    func makeMyVotesViewController(user: User) -> MyVotesViewController {
        let viewModel = self.viewModelsFactory.makeMyVotesViewModel(user: user)
        let viewController = MyVotesViewController(viewModel: viewModel)
        
        return viewController
    }
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = self.viewModelsFactory.makeHomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel)
        
        return viewController
    }
    
    func makeCreateVoteViewController(user: User) -> CreateVoteViewController {
        let viewModel = self.viewModelsFactory.makeCreateVoteViewModel(user: user)
        let viewController = CreateVoteViewController(viewModel: viewModel)
        
        return viewController
    }
    
    func makeVoteViewController(vote: Vote) -> VoteViewController {
        let viewModel = self.viewModelsFactory.makeVoteViewModel(vote: vote)
        let viewController = VoteViewController(viewModel: viewModel)
        
        return viewController
    }
    
    func makeVoteResultViewController(vote: Vote) -> VoteResultViewController {
        let viewModel = self.viewModelsFactory.makeVoteResultViewModel(vote: vote)
        let viewController = VoteResultViewController(viewModel: viewModel)
        
        return viewController
    }
}
