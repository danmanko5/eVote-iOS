//
//  FirestoreProvider.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

protocol FirestoreProvider {
    
    var firestore: Firestore { get }
    
}
