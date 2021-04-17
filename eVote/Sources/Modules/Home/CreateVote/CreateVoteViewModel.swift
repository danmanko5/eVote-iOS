//
//  CreateVoteViewModel.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class CreateVoteViewModel {
    
    let user: User
    let voteCreatorProvider: VoteCreatorProvider
    
    private(set) var title: String = ""
    private(set) var description: String? = nil
    private(set) var options: [VoteOption] = [VoteOption.empty, VoteOption.empty]
    
    var onUpdateOptions: VoidClosure?
    var onUpdate: VoidClosure?
    
    init(user: User, voteCreatorProvider: VoteCreatorProvider) {
        self.user = user
        self.voteCreatorProvider = voteCreatorProvider
    }
    
    func createVote(completion: @escaping VoidClosure) {
        guard self.couldCreateVote() else {
            completion()
            return
        }
        
        self.voteCreatorProvider.createVote(user: self.user, title: self.title, description: self.description, options: self.options, completion: completion)
    }
    
    func couldCreateVote() -> Bool {
        return !self.title.isEmpty &&
            self.options.count >= 2 &&
            self.options.compactMap({ $0.name }).uniqued().count == self.options.count
    }
    
    func updateTitle(_ title: String) {
        self.title = title
        self.onUpdate?()
    }
    
    func updateDescription(_ description: String?) {
        self.description = description
        self.onUpdate?()
    }
    
    func updateOption(option: VoteOption, name: String) {
        guard let index = self.options.firstIndex(where: { $0.id == option.id }) else { return }
        
        let updatedOption = VoteOption(id: option.id, name: name, voteCount: option.voteCount)
        
        self.options.remove(at: index)
        self.options.insert(updatedOption, at: index)
        
        self.onUpdate?()
    }
    
    func addOption() {
        self.options.append(VoteOption.empty)
        self.onUpdateOptions?()
    }
}
