//
//  HomeViewModelsFactory.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class HomeViewModelsFactory {
    
    let urlHandler: URLHandler
    let logoutProvider: AuthenticationLogoutProvider
    let userDeletionProvider: AuthenticationUserDeletionProvider

    init(urlHandler: URLHandler,
         logoutProvider: AuthenticationLogoutProvider,
         userDeletionProvider: AuthenticationUserDeletionProvider) {
        self.urlHandler = urlHandler
        self.logoutProvider = logoutProvider
        self.userDeletionProvider = userDeletionProvider
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        let viewModel = SettingsViewModel(urlHandler: self.urlHandler,
                                          logoutProvider: self.logoutProvider,
                                          userDeletionProvider: self.userDeletionProvider)
        return viewModel
    }
    
    func makeMyVotesViewModel() -> MyVotesViewModel {
        let viewModel = MyVotesViewModel()
        return viewModel
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        let viewModel = HomeViewModel()
        return viewModel
    }
}
