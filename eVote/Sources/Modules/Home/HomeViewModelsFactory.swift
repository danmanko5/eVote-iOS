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
    let voteProvider: VoteProvider
    let keyValueStorage: KeyValueStorage

    init(urlHandler: URLHandler,
         logoutProvider: AuthenticationLogoutProvider,
         userDeletionProvider: AuthenticationUserDeletionProvider,
         voteCreatorProvider: VoteCreatorProvider,
         votesProvider: VotesProvider,
         voteProvider: VoteProvider,
         keyValueStorage: KeyValueStorage) {
        self.urlHandler = urlHandler
        self.logoutProvider = logoutProvider
        self.userDeletionProvider = userDeletionProvider
        self.voteCreatorProvider = voteCreatorProvider
        self.votesProvider = votesProvider
        self.voteProvider = voteProvider
        self.keyValueStorage = keyValueStorage
    }
    
    func makeSettingsViewModel(user: User) -> SettingsViewModel {
        let viewModel = SettingsViewModel(user: user,
                                          urlHandler: self.urlHandler,
                                          logoutProvider: self.logoutProvider,
                                          userDeletionProvider: self.userDeletionProvider,
                                          keyValueStorage: self.keyValueStorage)
        return viewModel
    }
    
    func makeMyVotesViewModel(user: User) -> MyVotesViewModel {
        let viewModel = MyVotesViewModel(user: user, votesProvider: self.votesProvider, voteProvider: self.voteProvider)
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
    
    func makeVoteViewModel(vote: Vote) -> VoteViewModel {
        let viewModel = VoteViewModel(vote: vote, voteProvider: self.voteProvider)
        return viewModel
    }
    
    func makeVoteResultViewModel(vote: Vote) -> VoteResultViewModel {
        let viewModel = VoteResultViewModel(vote: vote)
        return viewModel
    }
    
}
