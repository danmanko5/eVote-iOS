//
//  CollectionReferenceProvider.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

protocol CollectionReferenceProvider: FirestoreProvider {
}

extension CollectionReferenceProvider {
    
    var usersReference: CollectionReference {
        return self.firestore.collection(User.collectionName)
    }
    
    var votesReference: CollectionReference {
        return self.firestore.collection(Vote.collectionName)
    }
}

