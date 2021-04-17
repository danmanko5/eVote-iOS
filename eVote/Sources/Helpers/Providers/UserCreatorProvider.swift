//
//  UserCreatorProvider.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

final class UserCreatorProvider: FirestoreProvider {
    
    let firestore: Firestore
    
    init(firestore: Firestore) {
        self.firestore = firestore
    }
    
    func createUser(dataModel: ProfileSetupDataModel, userId: Identifier, completion: @escaping OptionalUserClosure) {
        
        let user = User(id: userId, username: dataModel.username)
        
        let document = FirestoreDocument<User>(id: userId, firestore: self.firestore)
        document.update(element: user) { (succeed) in
            guard succeed else {
                completion(nil)
                return
            }
            completion(user)
        }
    }
}
