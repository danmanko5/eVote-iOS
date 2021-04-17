//
//  StorableObservable.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

class StorableObservable<T> {
    var value: T
    
    init(value: T) {
        self.value = value
    }
    
    func observe(_ observer: AnyObject, closure: @escaping (T) -> Void) {
    }
}
