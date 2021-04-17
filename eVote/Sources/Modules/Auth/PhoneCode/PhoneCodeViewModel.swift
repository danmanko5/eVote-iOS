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
    
    var isAuthenticating: StorableObservable<Bool> {
        return self.authenticator.isAuthenticating
    }
    
    init(authenticator: Authenticator, firestore: Firestore) {
        self.authenticator = authenticator
        self.firestore = firestore
    }
    
    func confirmAuthentication(with code: String, completion: @escaping BoolClosure) {
        self.authenticator.confirmAuthentication(with: code, completion: completion)
    }
    
    func resentCode(completion: @escaping BoolClosure) {
        self.authenticator.resendCode(completion: completion)
    }
    
    func cancel() {
        self.authenticator.cancel()
    }
}
