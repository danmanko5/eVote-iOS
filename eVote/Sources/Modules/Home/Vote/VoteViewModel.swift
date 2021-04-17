//
//  VoteViewModel.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class VoteViewModel {
    
    let vote: Vote
    let voteProvider: VoteProvider
    
    var hasParticipated: Bool {
        self.voteProvider.hasParticipated(in: self.vote)
    }
    
    var canVote: Bool {
        self.selectedOption != nil && !self.hasParticipated
    }
    
    private var selectedOption: VoteOption?
    private(set) var finishedVote: Vote?
    
    init(vote: Vote, voteProvider: VoteProvider) {
        self.vote = vote
        self.voteProvider = voteProvider
    }
    
    func isSelected(option: VoteOption) -> Bool {
        self.selectedOption == option
    }
    
    func vote(completion: @escaping VoidClosure) {
        guard let option = self.selectedOption else {
            completion()
            return
        }
        
        self.voteProvider.vote(self.vote, option: option) { [weak self] vote in
            self?.finishedVote = vote
            completion()
        }
    }
    
    func select(_ option: VoteOption) {
        self.selectedOption = option
    }
}
