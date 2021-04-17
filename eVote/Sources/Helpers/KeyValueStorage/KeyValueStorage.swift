//
//  KeyValueStorage.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

protocol KeyValueStorage: class {
    func set(_ value: Any?, forKey: String)
    func object(forKey: String) -> Any?
}

enum KeyValueStorageKey {
    static let participatedVotes: String = "participatedVotesKey"
}
