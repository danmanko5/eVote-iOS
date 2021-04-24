//
//  AuthViewModelsFactory.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation
import FirebaseFirestore

final class AuthViewModelsFactory {

    let authenticator: Authenticator
    let firestore: Firestore
    let keyValueStorage: KeyValueStorage
    
    init(authenticator: Authenticator,
         firestore: Firestore,
         keyValueStorage: KeyValueStorage) {
        self.authenticator = authenticator
        self.firestore = firestore
        self.keyValueStorage = keyValueStorage
    }
    
    func makePhoneNumberViewModel() -> PhoneNumberViewModel {
        let viewModel = PhoneNumberViewModel(authenticator: self.authenticator)
        return viewModel
    }
    
    func makePhoneCodeViewModel() -> PhoneCodeViewModel {
        let viewModel = PhoneCodeViewModel(authenticator: self.authenticator, firestore: self.firestore, keyValueStorage: self.keyValueStorage)
        return viewModel
    }
}
