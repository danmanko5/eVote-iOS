//
//  QueryDocumentSnapshot+JSON.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import FirebaseFirestore

extension DocumentSnapshot {
    
    private static let idKey = "id"
    
    var fl_json: [String: Any] {
        guard var data = self.data() else {
            return [:]
        }
        
        if data[DocumentSnapshot.idKey] == nil {
            data[DocumentSnapshot.idKey] = self.documentID
        }
        
        return data
    }
    
}
