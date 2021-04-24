//
//  VoteOption.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

class VoteOption: Hashable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case voteCount
    }
    
    static func == (lhs: VoteOption, rhs: VoteOption) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
         hasher.combine(self.id)
    }
    
    let id: Identifier
    
    let name: String
    let voteCount: Int
    
    init(id: Identifier, name: String, voteCount: Int) {
        self.id = id
        self.name = name
        self.voteCount = voteCount
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = (try container.decode(String.self, forKey: .name)).decrypted
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name.encrypted, forKey: .name)
        try container.encode(self.voteCount, forKey: .voteCount)
    }
}
