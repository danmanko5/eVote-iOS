//
//  HomeViewModel.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class HomeViewModel {
    
    let votesProvider: VotesProvider
    
    private let votesCollection: Collection<Vote>
    private var votes: [Vote] {
        return self.votesCollection.elements
    }
    
    var onUpdate: VoidClosure?
    
    init(votesProvider: VotesProvider) {
        self.votesProvider = votesProvider
        
        self.votesCollection = votesProvider.allVotes()
        
        self.votesCollection.observe(self) { [weak self] _ in
            self?.onUpdate?()
        }
    }
    
    func numberOfItems() -> Int {
        return self.votes.count
    }
    
    func vote(for indexPath: IndexPath) -> Vote? {
        return self.votes[safe: indexPath.item]
    }
}
