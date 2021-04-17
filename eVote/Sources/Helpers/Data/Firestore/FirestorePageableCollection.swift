//
//  FirestorePageableCollection.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

final class FirestorePageableCollection<Element: Collectionable & Codable>: PageableCollection<Element> {
    
    private let elementsPerPage = 15
    
    let firestore: Firestore
    
    private let query: Query
    private let collection: CollectionReference
    private let storage: ValueStorableObservableNotifiable<[Element]>
    private let loadOnce: Bool
    
    private var lastLoadedDocument: DocumentSnapshot?
    private var isLoading: Bool = false
    
    private var pages: [[Element]] = []
    
    init(firestore: Firestore,
         loadOnce: Bool = false,
         collectionPath: CollectionReference? = nil,
         query: ((CollectionReference) -> Query)? = nil) {
        self.firestore = firestore
        let collection = collectionPath ?? firestore.collection(Element.collectionName)
        self.query = query?(collection) ?? collection
        self.collection = collection
        self.storage = ValueStorableObservableNotifiable<[Element]>(value: [])
        self.loadOnce = loadOnce
        
        super.init()
        
        self.loadMore()
    }
    
    override var canLoadMore: Bool {
        return self.elementsPerPage == self.pages.last?.count || self.pages.isEmpty
    }
    
    override var elements: [Element] {
        return self.storage.value
    }
    
    override func observe(_ observer: AnyObject, closure: @escaping ([Element]) -> Void) {
        self.storage.observe(observer, closure: closure)
    }
    
    override func loadMore() {
        guard self.canLoadMore && !self.isLoading else {
            return
        }

        self.isLoading = true
        let pageIndex = self.pages.count
        self.pages.append([])
        
        
        var paginationQuery = self.query.limit(to: self.elementsPerPage)
        if let lastLoadedDocument = self.lastLoadedDocument {
            paginationQuery = paginationQuery.start(afterDocument: lastLoadedDocument)
        }
        
        let parseClosure: FIRQuerySnapshotBlock = { [weak self] (snapshot, error) in
            defer { self?.isLoading = false }
            
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results \(String(describing: error))")
                return
            }
            
            guard self?.pages[safe: pageIndex] != nil else {
                print("Cannot save loaded data because page doesn't exist")
                return
            }
            
            if pageIndex + 1 == self?.pages.count {
                self?.lastLoadedDocument = snapshot.documents.last
            }
            
            let models = snapshot.documents.compactMap { try? Element.decode(from: $0.fl_json) }
            self?.pages[pageIndex] = models
            
            let allElements: [Element] = self?.pages.reduce([], {
                 $0 + $1
            }) ?? []
            self?.storage.notifyAll(value: allElements)
        }
        
        if self.loadOnce {
            paginationQuery.getDocuments(completion: parseClosure)
        }
        else {
            paginationQuery.addSnapshotListener(parseClosure)
        }
    }

}
