//
//  FirebaseAuthenticator.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

final class FirebaseAuthenticator: Authenticator & AuthenticationStateProvider & AuthenticationLogoutProvider & AuthenticationUserDeletionProvider & FirestoreDataLoader & CollectionReferenceProvider {
    
    let auth: Auth
    let phoneAuthProvider: PhoneAuthProvider
    let firestore: Firestore
    
    private let authenticationStateNotifiable: ValueStorableObservableNotifiable<AuthenticationState>
    private let isAuthenticatingNotifiable: ValueStorableObservableNotifiable<Bool>
    private var authSession: AuthSession?
    private var userDocumentListener: ListenerRegistration?
    
    var firestoreDataLoaders: [AnyObject] = []
    
    var authenticationState: StorableObservable<AuthenticationState> {
        return self.authenticationStateNotifiable
    }
    
    var isAuthenticating: StorableObservable<Bool> {
        return self.isAuthenticatingNotifiable
    }
    
    init(auth: Auth, phoneAuthProvider: PhoneAuthProvider, firestore: Firestore) {
        self.auth = auth
        self.firestore = firestore
        self.phoneAuthProvider = phoneAuthProvider
        
        self.authenticationStateNotifiable = ValueStorableObservableNotifiable<AuthenticationState>(value: .retrieving)
        self.isAuthenticatingNotifiable = ValueStorableObservableNotifiable<Bool>(value: false)
        
        self.retrieveUserIfNeeded()
    }
    
    func authenticate(with phoneNumber: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        guard !self.isAuthenticating.value else { return }
        
        self.isAuthenticatingNotifiable.notifyAll(value: true)
        
        self.phoneAuthProvider.verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
            guard let sself = self else { return }
            sself.authSession = AuthSession(phoneNumber: phoneNumber,
                                            verificationID: verificationID)
            sself.isAuthenticatingNotifiable.notifyAll(value: false)
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(Void()))
            }
        }
    }
    
    func confirmAuthentication(with code: String, completion: @escaping BoolClosure) {
                guard let authSession = self.authSession else { return }
        
        guard !self.isAuthenticating.value else { return }
        self.isAuthenticatingNotifiable.notifyAll(value: true)
        
        let credential = self.phoneAuthProvider.credential(withVerificationID: authSession.verificationID, verificationCode: code)
        self.auth.signIn(with: credential) { [weak self] (result, error) in
            guard let sself = self else { return }
            let success = error == nil
            sself.isAuthenticatingNotifiable.notifyAll(value: false)
            if success {
                sself.retrieveUserIfNeeded()
            }
            completion(success)
        }
    }
    
    func resendCode(completion: @escaping BoolClosure) {
        guard let phoneNumber = self.authSession?.phoneNumber, !self.isAuthenticating.value else {
            completion(false)
            return
        }
        
        self.isAuthenticatingNotifiable.notifyAll(value: true)
        
        self.phoneAuthProvider.verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
            guard let sself = self else { return }
            
            let success = error == nil
            if success { // Override only if succeded to keep existing authSession.
                sself.authSession = AuthSession(phoneNumber: phoneNumber,
                                                verificationID: verificationID)
            }
            
            sself.isAuthenticatingNotifiable.notifyAll(value: false)
            completion(success)
        }
    }
    
    func logout() {
        do {
            try self.auth.signOut()
            self.userDocumentListener?.remove()
            self.userDocumentListener = nil
            self.authenticationStateNotifiable.notifyAll(value: .notAuthenticated)
        } catch {
            
        }
    }
    
    func cancel() {
        guard self.isAuthenticating.value else {
            return
        }
        
        self.isAuthenticatingNotifiable.notifyAll(value: false)
    }
    
    func deleteUser(completion: @escaping BoolClosure) {
    }
    
    private func retrieveUserIfNeeded() {
        guard let userId = self.auth.currentUser?.uid else {
            self.authenticationStateNotifiable.notifyAll(value: .notAuthenticated)
            return
        }
        
        self.loadDocument(id: userId, loadOnce: true, source: .cache) { [weak self] (cachedUser: User?) in
            self?.loadDocument(id: userId, loadOnce: true, source: .server, completion: { (user: User?) in
                let state: AuthenticationState
                if let u = user ?? cachedUser {
                    state = .authenticated(u)
                    self?.userDocumentListener?.remove()
                    self?.userDocumentListener = nil
                }
                else {
                    state = .authenticatedUncomplete(userId)
                    if self?.userDocumentListener == nil {
                        var firstTime = true
                        self?.userDocumentListener = self?.usersReference.document(userId).addSnapshotListener { [weak self] (_, _) in
                            guard !firstTime else {
                                firstTime = false
                                return
                            }
                            self?.retrieveUserIfNeeded()
                        }
                    }
                }
                
                self?.authenticationStateNotifiable.notifyAll(value: state)
                self?.observeUserUpdates()
            })
        }
    }
    
    private func observeUserUpdates() {
        guard self.userDocumentListener == nil,
            case let .authenticated(user) = self.authenticationState.value else { return }
        
        self.userDocumentListener = self.usersReference.document(user.id).addSnapshotListener { [weak self] (_ , _) in
            self?.loadDocument(id: user.id, loadOnce: true, source: .server, completion: { (user: User?) in
                guard let user = user else { return }
                
                self?.authenticationStateNotifiable.value = .authenticated(user)
            })
        }
    }
    
    private struct AuthSession {
        let phoneNumber: String
        let verificationID: String
        
        init?(phoneNumber: String, verificationID: String?) {
            guard let ID = verificationID else {
                return nil
            }
            self.phoneNumber = phoneNumber
            self.verificationID = ID
        }
    }
}
