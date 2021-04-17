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
    let voteCreatorProvider: VoteCreatorProvider
    let votesProvider: VotesProvider

    init(urlHandler: URLHandler,
         logoutProvider: AuthenticationLogoutProvider,
         userDeletionProvider: AuthenticationUserDeletionProvider,
         voteCreatorProvider: VoteCreatorProvider,
         votesProvider: VotesProvider) {
        self.urlHandler = urlHandler
        self.logoutProvider = logoutProvider
        self.userDeletionProvider = userDeletionProvider
        self.voteCreatorProvider = voteCreatorProvider
        self.votesProvider = votesProvider
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
        let viewModel = HomeViewModel(votesProvider: self.votesProvider)
        return viewModel
    }
    
    func makeCreateVoteViewModel(user: User) -> CreateVoteViewModel {
        let viewModel = CreateVoteViewModel(user: user, voteCreatorProvider: self.voteCreatorProvider)
        return viewModel
    }
}
