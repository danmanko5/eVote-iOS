//
//  VotesProvider.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

final class VotesProvider: CollectionReferenceProvider, FirestoreDataLoader {
    
    let firestore: Firestore
    var firestoreDataLoaders: [AnyObject] = []
    
    init(firestore: Firestore) {
        self.firestore = firestore
    }
    
    func allVotes() -> Collection<Vote> {
        let collection = FirestoreCollection<Vote>(firestore: self.firestore)
        return collection
    }
}
