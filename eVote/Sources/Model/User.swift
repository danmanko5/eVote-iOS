//
//  User.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

typealias Identifier = String

class User: Hashable, Collectionable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
         hasher.combine(self.id)
    }
    
    let id: Identifier
    
    let username: String
    
    static let collectionName = "users"
    
    init(id: Identifier, username: String) {
        self.id = id
        self.username = username
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.username = (try container.decode(String.self, forKey: .username)).privateDecrypted
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.username.privateEncrypted, forKey: .username)
    }
}
