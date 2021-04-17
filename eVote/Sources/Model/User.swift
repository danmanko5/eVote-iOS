//
//  User.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

typealias Identifier = String

struct User: Hashable, Collectionable, Codable {
    let id: Identifier
    
    let username: String
    
    static let collectionName = "users"
}
