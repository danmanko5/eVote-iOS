//
//  FirestoreDocument.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

final class FirestoreDocument<Element: Collectionable & Codable>: MutableDocument<Element> {
    
    let id: String
    let firestore: Firestore
    let loadOnce: Bool
    let source: FirestoreSource
    
    private let collection: CollectionReference
    private let document: DocumentReference
    private let storage: ValueStorableObservableNotifiable<Element?>
    
    private var isObserving = false
    
    init(id: Identifier, firestore: Firestore, loadOnce: Bool = false, source: FirestoreSource = .default, collectionPath: CollectionReference? = nil) {
        self.id = id
        self.firestore = firestore
        self.loadOnce = loadOnce
        self.source = source
        self.collection = collectionPath ?? firestore.collection(Element.collectionName)
        self.document = self.collection.document(id)
        self.storage = ValueStorableObservableNotifiable<Element?>(value: nil)
        
        super.init()
    }
    
    init?(elementJSON: [String: Any], firestore: Firestore) {
        
        func verify(json: [String: Any]) throws {
            var verificationJson = elementJSON
            verificationJson["id"] = "temp"
            _ = try Element.decode(from: verificationJson)
        }
        
        if (try? verify(json: elementJSON)) == nil {
            return nil
        }
        
        self.loadOnce = false
        self.source = .default
        self.firestore = firestore
        self.collection = firestore.collection(Element.collectionName)
        self.document = self.collection.addDocument(data: elementJSON)
        self.storage = ValueStorableObservableNotifiable<Element?>(value: nil)
        self.id = self.document.documentID
    }
    
    override var element: Element? {
        return self.storage.value
    }
    
    override func observe(_ observer: AnyObject, closure: @escaping (Element?) -> Void) {
        self.storage.observe(observer, closure: closure)
        self.fetchAndSetupObservationIfNeeded()
    }
    
    private func fetchAndSetupObservationIfNeeded() {
        guard !self.isObserving else { return }
        
        self.isObserving = true
        
        let parseClosure: FIRDocumentSnapshotBlock = { [weak self] (snapshot, error) in
            guard let json = snapshot?.fl_json,
                let element = try? Element.decode(from: json) else {
                    self?.storage.notifyAll(value: nil)
                    return
            }
            
            self?.storage.notifyAll(value: element)
        }
        
        if self.loadOnce {
            self.document.getDocument(source: self.source, completion: parseClosure)
        }
        else {
            self.document.addSnapshotListener(parseClosure)
        }
    }
    
    override func update(element: Element, completion: @escaping BoolClosure = { _ in }) {
        guard element.id == self.id else {
            assert(true, "IDs are different. Current element \(String(describing: self.element?.id)). New element \(element.id)")
            completion(false)
            return
        }
        
        guard let data = try? element.jsonObject(excludeValuesWithKeys: ["id"]) else {
            completion(false)
            return
        }
        
        self.document.setData(data) { [weak self] (error) in
            let success = error == nil
            completion(success)
            
            if success {
                self?.storage.notifyAll(value: element)
            }
        }
    }
    
    override func delete(completion: @escaping BoolClosure = { _ in }) {
        self.document.delete { [weak self] error in
            let success = error == nil
            completion(success)
            
            if success {
                self?.storage.notifyAll(value: nil)
            }
        }
    }
}
