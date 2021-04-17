//
//  Collection.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

class Collection<Element: Collectionable & Codable> {
    
    var elements: [Element] {
        return []
    }
    
    func observe(_ observer: AnyObject, closure: @escaping ([Element]) -> Void) {
        print("WARNING! Used not implemented method.")
    }
}

class MutableCollection<Element: Collectionable & Codable>: Collection<Element> {
    
    func add(_ elementJSON: [String: Any], completion: @escaping BoolClosure) {
        print("WARNING! Used not implemented method.")
    }
    
    func update(_ element: Element, completion: @escaping BoolClosure) {
        print("WARNING! Used not implemented method.")
    }
    
    func delete(_ elementId: String, completion: @escaping BoolClosure) {
        print("WARNING! Used not implemented method.")
    }
}

class PageableCollection<Element: Collectionable & Codable>: Collection<Element> {
    
    var canLoadMore: Bool {
        return true
    }
    
    func loadMore() {
        print("WARNING! Used not implemented method.")
    }
}
