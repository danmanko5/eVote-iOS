//
//  PhoneCodeViewModel.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

final class PhoneCodeViewModel {
    
    let authenticator: Authenticator
    let firestore: Firestore
    let keyValueStorage: KeyValueStorage
    
    var isAuthenticating: StorableObservable<Bool> {
        return self.authenticator.isAuthenticating
    }
    
    init(authenticator: Authenticator, firestore: Firestore, keyValueStorage: KeyValueStorage) {
        self.authenticator = authenticator
        self.firestore = firestore
        self.keyValueStorage = keyValueStorage
    }
    
    func confirmAuthentication(with code: String, completion: @escaping BoolClosure) {
        self.authenticator.confirmAuthentication(with: code) { (completed) in
            if completed {
                let key = String.randomString(length: 16)
                self.keyValueStorage.set(key, forKey: KeyValueStorageKey.privateKey)
            }
            completion(completed)
        }
    }
    
    func resentCode(completion: @escaping BoolClosure) {
        self.authenticator.resendCode(completion: completion)
    }
    
    func cancel() {
        self.authenticator.cancel()
    }
}

fileprivate extension String {
    
    static func randomString(length: Int) -> String {
        
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
