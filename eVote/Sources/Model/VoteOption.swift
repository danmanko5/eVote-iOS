//
//  VoteOption.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

struct VoteOption: Hashable, Codable {
    
    static let empty: VoteOption = .init(id: UUID().uuidString, name: "", voteCount: 0)
    
    let id: Identifier
    
    let name: String
    let voteCount: Int
    
    init(id: Identifier, name: String, voteCount: Int) {
        self.id = id
        self.name = name
        self.voteCount = voteCount
    }
}
