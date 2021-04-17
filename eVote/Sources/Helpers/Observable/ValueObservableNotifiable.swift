//
//  ValueObservableNotifiable.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class ValueObservableNotifiable<T>: Observable<T> {
    
    private var observers: [WeakObserver<T>]
    
    override init() {
        self.observers = []
    }
    
    override func observe(_ observer: AnyObject, closure: @escaping (T) -> Void) {
        let weakObserver = WeakObserver(observer: observer,
                                        closure: closure)
        self.observers.append(weakObserver)
    }
    
    func notifyAll(value: T) {
        self.observers = self.observers.filter { $0.observer != nil }
        self.observers.forEach { $0.closure(value) }
    }
}

extension ValueObservableNotifiable where T == Void {
    
    func notifyAll() {
        self.notifyAll(value: Void())
    }
}
