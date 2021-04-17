//
//  Authenticator.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

enum AuthenticationState {
    case retrieving
    case notAuthenticated
    case authenticatedUncomplete(Identifier)
    case authenticated(User)
}

protocol AuthenticationStateProvider {
    var authenticationState: StorableObservable<AuthenticationState> { get }
}

extension AuthenticationStateProvider {
    
    var currentUserId: Identifier? {
        switch self.authenticationState.value {
        case .authenticatedUncomplete(let id):
            return id
        case .authenticated(let user):
            return user.id
        default:
            return nil
        }
    }
    
    var currentUser: User? {
        guard case let .authenticated(user) = self.authenticationState.value else {
            return nil
        }
        
        return user
    }
}

protocol PhoneNumberAuthenticator {
    func authenticate(with phoneNumber: String, completion: @escaping ((Result<Void, Error>) -> Void))
    func confirmAuthentication(with code: String, completion: @escaping BoolClosure)
    func resendCode(completion: @escaping BoolClosure)
}

protocol Authenticator: PhoneNumberAuthenticator {
    var isAuthenticating: StorableObservable<Bool> { get }
    func cancel()
}

protocol AuthenticationLogoutProvider {
    func logout()
}

protocol AuthenticationUserDeletionProvider {
    func deleteUser(completion: @escaping BoolClosure)
}
