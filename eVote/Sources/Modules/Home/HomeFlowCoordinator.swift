//
//  HomeFlowCoordinator.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class HomeFlowCoordinator: FlowCoordinator {
    
    private enum RootFeatureTab {
        case home
        case votes
        case settings
    }
    
    let uiFactory: HomeFlowUIFactory
    let user: User
    
    let rootViewController: UIViewController
    var childFlowCoordinators: [FlowCoordinator]
    
    private let tabBarController: UITabBarController // Same as rootViewController in this case
    
    init(uiFactory: HomeFlowUIFactory,
         user: User) {
        self.uiFactory = uiFactory
        self.user = user
        
        let rootViewController = uiFactory.makeRootViewController()
        rootViewController.tabBar.tintColor = .systemBlue
        rootViewController.view.backgroundColor = .systemBackground
        
        self.rootViewController = rootViewController
        self.tabBarController = rootViewController
        self.childFlowCoordinators = []
        
        let homeViewController = uiFactory.makeHomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "icon-tab-bar-home"), tag: 0)
        
        let myVotesViewController = uiFactory.makeMyVotesViewController()
        myVotesViewController.tabBarItem = UITabBarItem(title: "My Votes", image: #imageLiteral(resourceName: "icon-tab-bar-my-votes"), tag: 1)
        
        let settingsViewController = uiFactory.makeSettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "icon-tab-bar-settings"), tag: 2)
        
        rootViewController.viewControllers = [
            uiFactory.makeNavigationController(with: homeViewController),
            uiFactory.makeNavigationController(with: myVotesViewController),
            uiFactory.makeNavigationController(with: settingsViewController)
        ]
        
        homeViewController.onCreateVote = { [weak self, weak homeViewController] in
            guard let sself = self, let vc = homeViewController else { return }
            
            sself.showCreateVoteViewController(from: vc)
        }
    }
    
    func install() {
    }
    
    private func showCreateVoteViewController(from sender: UIViewController) {
        let viewController = self.uiFactory.makeCreateVoteViewController(user: self.user)
        viewController.onDone = { [weak viewController] in
            viewController?.dismiss(animated: true, completion: nil)
        }
        viewController.onCancel = { [weak viewController] in
            viewController?.dismiss(animated: true, completion: nil)
        }
        
        let navigationController = self.uiFactory.makeNavigationController(with: viewController)
        sender.present(navigationController, animated: true, completion: nil)
    }
    
    private func showError(from sender: UIViewController, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
}
