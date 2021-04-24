//
//  UIFactoriesProvider.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

final class UIFactoriesProvider {
    
    let keyValueStorage: KeyValueStorage
    let urlHandler: URLHandler
    let userCreatorProvider: UserCreatorProvider
    let firestore: Firestore
    let authenticator: Authenticator
    let logoutProvider: AuthenticationLogoutProvider
    let userDeletionProvider: AuthenticationUserDeletionProvider
    let voteCreatorProvider: VoteCreatorProvider
    let votesProvider: VotesProvider
    let voteProvider: VoteProvider
    
    init(keyValueStorage: KeyValueStorage,
         urlHandler: URLHandler,
         userCreatorProvider: UserCreatorProvider,
         firestore: Firestore,
         authenticator: Authenticator,
         logoutProvider: AuthenticationLogoutProvider,
         userDeletionProvider: AuthenticationUserDeletionProvider,
         voteCreatorProvider: VoteCreatorProvider,
         votesProvider: VotesProvider,
         voteProvider: VoteProvider) {
        
        self.keyValueStorage = keyValueStorage
        self.urlHandler = urlHandler
        self.userCreatorProvider = userCreatorProvider
        self.firestore = firestore
        self.authenticator = authenticator
        self.logoutProvider = logoutProvider
        self.userDeletionProvider = userDeletionProvider
        self.voteCreatorProvider = voteCreatorProvider
        self.votesProvider = votesProvider
        self.voteProvider = voteProvider
    }
    
    // MARK: - App
    
    func makeAppUIFactory() -> AppUIFactory {
        let uiFactory = AppUIFactory()
        return uiFactory
    }
    
    // MARK: - Home
    
    func makeHomeUIFactory() -> HomeUIFactory {
        let viewModelsFactory = self.makeHomeViewModelsFactory()
        let uiFactory = HomeUIFactory(viewModelsFactory: viewModelsFactory)
        return uiFactory
    }
    
    private func makeHomeViewModelsFactory() -> HomeViewModelsFactory {
        let factory = HomeViewModelsFactory(urlHandler: self.urlHandler,
                                            logoutProvider: self.logoutProvider,
                                            userDeletionProvider: self.userDeletionProvider,
                                            voteCreatorProvider: self.voteCreatorProvider,
                                            votesProvider: self.votesProvider,
                                            voteProvider: self.voteProvider)
        return factory
    }
    
    // MARK: - Auth
    
    func makeAuthUIFactory() -> AuthUIFactory {
        let viewModelsFactory = self.makeAuthViewModelsFactory()
        let uiFactory = AuthUIFactory(viewModelsFactory: viewModelsFactory)
        return uiFactory
    }
    
    private func makeAuthViewModelsFactory() -> AuthViewModelsFactory {
        let factory = AuthViewModelsFactory(authenticator: self.authenticator, firestore: self.firestore, keyValueStorage: self.keyValueStorage)
        return factory
    }
    
    // MARK: - Profile Setup
    
    func makeProfileSetupUIFactory() -> ProfileSetupUIFactory {
        let viewModelsFactory = self.makeProfileSetupViewModelsFactory()
        let uiFactory = ProfileSetupUIFactory(viewModelsFactory: viewModelsFactory)
        return uiFactory
    }
    
    private func makeProfileSetupViewModelsFactory() -> ProfileSetupViewModelsFactory {
        let factory = ProfileSetupViewModelsFactory(userCreatorProvider: self.userCreatorProvider)
        return factory
    }
}
