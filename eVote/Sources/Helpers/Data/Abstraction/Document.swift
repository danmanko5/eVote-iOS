//
//  Document.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

class Document<Element: Collectionable & Codable> {
    
    var element: Element? {
        return nil
    }
    
    func observe(_ observer: AnyObject, closure: @escaping (Element?) -> Void) {
        print("WARNING! Used not implemented method.")
    }
}

class MutableDocument<Element: Collectionable & Codable>: Document<Element> {
    
    func update(element: Element, completion: @escaping BoolClosure) {
        print("WARNING! Used not implemented method.")
    }
    
    func delete(completion: @escaping BoolClosure) {
        print("WARNING! Used not implemented method.")
    }
    
}
