//
//  FirestoreCollection.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

final class FirestoreCollection<Element: Collectionable & Codable>: MutableCollection<Element> {
    
    let firestore: Firestore
    
    private let query: Query
    private let collection: CollectionReference
    private let storage: ValueStorableObservableNotifiable<[Element]>
    
    init(firestore: Firestore, loadOnce: Bool = false, collectionPath: CollectionReference? = nil, query: ((CollectionReference) -> Query)? = nil) {
        self.firestore = firestore
        let collection = collectionPath ?? firestore.collection(Element.collectionName)
        self.query = query?(collection) ?? collection
        self.collection = collection
        self.storage = ValueStorableObservableNotifiable<[Element]>(value: [])
        
        super.init()
        
        let parseClosure: FIRQuerySnapshotBlock = { [weak self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results \(String(describing: error))")
                return
            }
            let models = snapshot.documents.compactMap { try? Element.decode(from: $0.fl_json) }
            self?.storage.notifyAll(value: models)
        }
        
        if loadOnce {
            self.query.getDocuments(completion: parseClosure)
        }
        else {
            self.query.addSnapshotListener(parseClosure)
        }
    }
    
    override var elements: [Element] {
        return self.storage.value
    }
    
    override func observe(_ observer: AnyObject, closure: @escaping ([Element]) -> Void) {
        self.storage.observe(observer, closure: closure)
    }
    
    override func add(_ elementJSON: [String : Any], completion: @escaping BoolClosure) {
        
        func verify(json: [String: Any]) throws {
            var verificationJson = elementJSON
            verificationJson["id"] = "temp"
            _ = try Element.decode(from: verificationJson)
        }
        
        do {
            try verify(json: elementJSON)
            
            self.collection.addDocument(data: elementJSON) { (error) in
                completion(error == nil)
            }
        }
        catch {
            completion(false)
        }
        
    }
    
    override func update(_ element: Element, completion: @escaping BoolClosure) {
        
        do {
            let json = try element.jsonObject()
            
            self.collection.document(element.id).updateData(json) { (error) in
                completion(error == nil)
            }
        }
        catch {
            completion(false)
        }
    }
    
    override func delete(_ elementId: String, completion: @escaping BoolClosure) {
        
        self.collection.document(elementId).delete { (error) in
            completion(error == nil)
        }
    }
}
