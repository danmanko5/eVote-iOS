//
//  ValueStorableObservableNotifiable.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class ValueStorableObservableNotifiable<T>: StorableObservable<T> {
    
    private var observers: [WeakObserver<T>]
    
    override init(value: T) {
        self.observers = []
        super.init(value: value)
    }
    
    override func observe(_ observer: AnyObject, closure: @escaping (T) -> Void) {
        let weakObserver = WeakObserver(observer: observer,
                                        closure: closure)
        self.observers.append(weakObserver)
    }
    
    func notifyAll(value: T) {
        self.value = value
        self.observers = self.observers.filter { $0.observer != nil }
        self.observers.forEach { $0.closure(value) }
    }
}

extension ValueStorableObservableNotifiable where T == Void {
    
    convenience init() {
        self.init(value: Void())
    }
    
    func notifyAll() {
        self.notifyAll(value: Void())
    }
}
