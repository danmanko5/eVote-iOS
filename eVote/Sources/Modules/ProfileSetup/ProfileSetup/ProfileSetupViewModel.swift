//
//  ProfileSetupViewModel.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class ProfileSetupViewModel {
    
    var onUpdate: VoidClosure?
    
    private var dataModel = ProfileSetupDataModel(username: "") {
        didSet {
            self.onUpdate?()
        }
    }
    
    let userId: Identifier
    let userCreatorProvider: UserCreatorProvider
    
    init(userId: Identifier, userCreatorProvider: UserCreatorProvider) {
        self.userId = userId
        self.userCreatorProvider = userCreatorProvider
    }
    
    func updateUsername(_ username: String) {
        self.dataModel = ProfileSetupDataModel(username: username)
    }
    
    func couldUpdateUser() -> Bool {
        return !self.dataModel.username.isEmpty
    }
    
    func updateUser(completion: @escaping OptionalUserClosure) {
        guard self.couldUpdateUser() else { return }
        
        self.userCreatorProvider.createUser(dataModel: self.dataModel, userId: self.userId, completion: completion)
    }
}
