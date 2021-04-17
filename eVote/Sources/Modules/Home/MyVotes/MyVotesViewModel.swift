//
//  MyVotesViewModel.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class MyVotesViewModel {
    
    enum Section: CaseIterable {
        case posted
        case participated
        
        var title: String {
            switch self {
            case .posted:
                return "Posted"
            case .participated:
                return "Participated"
            }
        }
    }
    
    let user: User
    let votesProvider: VotesProvider
    let voteProvider: VoteProvider
    
    let sections = Section.allCases
    
    private let votesCollection: Collection<Vote>
    private var votes: [Section: [Vote]] = [:]
    private(set) var selectedSectionIndex: Int = 0
    
    var onUpdate: VoidClosure?
    
    init(user: User, votesProvider: VotesProvider, voteProvider: VoteProvider) {
        self.user = user
        self.votesProvider = votesProvider
        self.voteProvider = voteProvider
        
        self.votesCollection = votesProvider.allVotes()
        
        self.votesCollection.observe(self) { [weak self] _ in
            self?.updateVotes()
        }
    }
    
    func updateVotes() {
        let allVotes = self.votesCollection.elements
        
        self.votes[.posted] = allVotes.filter{ $0.creatorId == self.user.id }
        self.votes[.participated] = allVotes.filter{ self.voteProvider.participatedVotesIds.contains($0.id) }
        
        self.onUpdate?()
    }
    
    func setSelectedSectionIndex(_ index: Int) {
        self.selectedSectionIndex = index
    }
    
    func vote(for indexPath: IndexPath) -> Vote? {
        guard let section = self.sections[safe: self.selectedSectionIndex] else { return nil }
        
        return self.votes[section]?[safe: indexPath.row]
    }
    
    func numberOfItems() -> Int {
        guard let section = self.sections[safe: self.selectedSectionIndex] else { return 0 }
        
        return self.votes[section]?.count ?? 0
    }
}
