//
//  ProfileSetupViewModelsFactory.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class ProfileSetupViewModelsFactory {
    
    let userCreatorProvider: UserCreatorProvider

    init(userCreatorProvider: UserCreatorProvider) {
        self.userCreatorProvider = userCreatorProvider
    }
    
    func makeProfileSetupViewModel(userId: Identifier) -> ProfileSetupViewModel {
        let viewModel = ProfileSetupViewModel(userId: userId,
                                              userCreatorProvider: self.userCreatorProvider)
        return viewModel
    }
}
