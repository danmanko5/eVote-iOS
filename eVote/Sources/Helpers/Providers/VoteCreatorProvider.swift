//
//  VoteCreatorProvider.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

final class VoteCreatorProvider: FirestoreProvider {
    
    let firestore: Firestore
    
    init(firestore: Firestore) {
        self.firestore = firestore
    }
    
    func createVote(user: User, title: String, description: String?, options: [VoteOption], completion: @escaping VoidClosure) {
        
        let id = UUID().uuidString
        let vote = Vote(id: id, username: user.username, title: title, description: description, options: options)
        
        let document = FirestoreDocument<Vote>(id: id, firestore: self.firestore)
        document.update(element: vote) { (succeed) in
            guard succeed else {
                completion()
                return
            }
            completion()
        }
    }
}
