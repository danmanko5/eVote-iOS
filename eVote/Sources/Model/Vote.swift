//
//  Vote.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

class Vote: Hashable, Collectionable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case creatorId
        case title
        case description
        case options
    }
    
    static func == (lhs: Vote, rhs: Vote) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
         hasher.combine(self.id)
    }
    
    let id: Identifier
    
    let username: String
    let creatorId: String
    let title: String
    let description: String?
    
    let options: [VoteOption]
    
    static let collectionName: String = "votes"
    
    init(id: Identifier, username: String, creatorId: String, title: String, description: String?, options: [VoteOption]) {
        self.id = id
        self.username = username
        self.creatorId = creatorId
        self.title = title
        self.description = description
        self.options = options
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.username = (try container.decode(String.self, forKey: .username)).decrypted
        self.creatorId = try container.decode(String.self, forKey: .creatorId)
        self.title = (try container.decode(String.self, forKey: .title)).decrypted
        self.description = (try? container.decodeIfPresent(String.self, forKey: .description))?.decrypted
        self.options = try container.decode([VoteOption].self, forKey: .options)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.username.encrypted, forKey: .username)
        try container.encode(self.creatorId, forKey: .creatorId)
        try container.encode(self.title.encrypted, forKey: .title)
        try container.encode(self.description?.encrypted, forKey: .description)
        try container.encode(self.options, forKey: .options)
    }
    
}

extension Vote {
    
    func rate(for option: VoteOption) -> Int {
        guard self.options.contains(option) else { return 0 }
        
        let totalVotesCount = self.options.reduce(0,{ $0 + $1.voteCount })
        
        return Int((Double(option.voteCount) / Double(totalVotesCount)) * 100 )
    }
    
    func totalVotes() -> Int {
        self.options.reduce(0,{ $0 + $1.voteCount })
    }
}
