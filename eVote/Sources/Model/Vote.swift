//
//  Vote.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

struct Vote: Hashable, Collectionable, Codable {
    
    let id: Identifier
    
    let username: String
    let title: String
    let description: String?
    
    let options: [VoteOption]
    
    static let collectionName: String = "votes"
}

extension Vote {
    
    func rate(for option: VoteOption) -> Int {
        guard self.options.contains(option) else { return 0 }
        
        let totalVotesCount = self.options.reduce(0,{ $0 + $1.voteCount })
        
        return Int((Double(option.voteCount) / Double(totalVotesCount)) * 100 )
    }
}
