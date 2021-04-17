//
//  VoteOption.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

struct VoteOption: Hashable, Codable {
    
    let id: Identifier
    
    let name: String
    let voteCount: Int
    
    init(id: Identifier, name: String, voteCount: Int) {
        self.id = id
        self.name = name
        self.voteCount = voteCount
    }
}
