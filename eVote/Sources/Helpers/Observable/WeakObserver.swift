//
//  WeakObserver.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

struct WeakObserver<T> {
    weak var observer: AnyObject?
    let closure: (T) -> Void
}
