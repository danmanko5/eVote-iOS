//
//  VoteProvider.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

final class VoteProvider: FirestoreProvider {
    
    let firestore: Firestore
    let keyValueStorage: KeyValueStorage
    
    private var participatedVotesIds: [Identifier] {
        set {
            self.keyValueStorage.set(newValue, forKey: KeyValueStorageKey.participatedVotes)
        }
        get {
            self.keyValueStorage.object(forKey: KeyValueStorageKey.participatedVotes) as? [Identifier] ?? []
        }
    }
    
    init(firestore: Firestore, keyValueStorage: KeyValueStorage) {
        self.firestore = firestore
        self.keyValueStorage = keyValueStorage
    }
    
    func hasParticipated(in vote: Vote) -> Bool {
        self.participatedVotesIds.contains(vote.id)
    }
    
    func vote(_ vote: Vote, option: VoteOption, completion: @escaping OptionalVoteClosure) {
        guard let optionIndex = vote.options.firstIndex(where: { $0.id == option.id }) else {
            completion(nil)
            return
        }
        
        let updatedOption = VoteOption(id: option.id, name: option.name, voteCount: option.voteCount + 1)
        
        var updatedOptions = vote.options
        updatedOptions.remove(at: optionIndex)
        updatedOptions.insert(updatedOption, at: optionIndex)
        
        let updatedVote = Vote(id: vote.id, username: vote.username, title: vote.title, description: vote.description, options: updatedOptions)
        let document = FirestoreDocument<Vote>(id: vote.id, firestore: self.firestore)
        document.update(element: updatedVote) { [weak self] (succeed) in
            guard succeed else {
                completion(nil)
                return
            }
            
            self?.participatedVotesIds.append(vote.id)
            completion(updatedVote)
        }
    }
}
