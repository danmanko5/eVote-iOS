//
//  FirestoreDataLoader.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

protocol FirestoreDataLoader: class, FirestoreProvider {
    var firestoreDataLoaders: [AnyObject] { get set }
}

extension FirestoreDataLoader {
    
    @discardableResult
    func loadCollection<Element: Codable & Collectionable>(loadOnce: Bool,
                                                            collectionPath: CollectionReference? = nil,
                                                            query: ((CollectionReference) -> Query)? = nil,
                                                            completion: (([Element]) -> Void)? = nil) -> FirestoreCollection<Element> {
        
        let collection = FirestoreCollection<Element>(firestore: self.firestore, loadOnce: loadOnce, collectionPath: collectionPath,  query: query)
        
        self.firestoreDataLoaders.append(collection)
        
        collection.observe(self) { [weak self, weak collection] (elements) in
            if loadOnce {
                self?.removeLoader(collection)
            }
            
            completion?(elements)
        }
        
        return collection
    }
    
    @discardableResult
    func loadDocument<Element: Codable & Collectionable>(id: Identifier,
                                                        loadOnce: Bool,
                                                        source: FirestoreSource = .default,
                                                        collectionPath: CollectionReference? = nil,
                                                        completion: ((Element?) -> Void)? = nil) -> FirestoreDocument<Element> {
        
        let document = FirestoreDocument<Element>(id: id, firestore: self.firestore, loadOnce: loadOnce, source: source, collectionPath: collectionPath)
        
        self.firestoreDataLoaders.append(document)
        
        document.observe(self) { [weak self, weak document] (fetchedObject) in
            
            if loadOnce {
                self?.removeLoader(document)
            }
            
            completion?(fetchedObject)
        }
        
        return document
    }
    
    private func removeLoader(_ loader: AnyObject?) {
        self.firestoreDataLoaders.removeAll(where: { element -> Bool in
            return element === loader
        })
    }
}
