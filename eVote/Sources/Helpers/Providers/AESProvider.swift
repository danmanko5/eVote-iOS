//
//  RSAProvider.swift
//  eVote
//
//  Created by Danylo Manko on 18.04.2021.
//

import Foundation
import CryptoKit

final class AESProvider {
    
    fileprivate static let shared = AESProvider()
    
    private var privateKey: String {
        UserDefaults.standard.string(forKey: KeyValueStorageKey.privateKey) ?? ""
    }
    
    private init() {}
    
    func encryptWithPublicKey(text: String) -> String? {
        if let keyData = AppInfo.publicKey.data(using: .utf8),
           let data = text.data(using: .utf8) {
            
            let key = SymmetricKey(data: keyData)
            do {
                let sealedBox =  try AES.GCM.seal(data, using: key)
                let encryptedMessage = sealedBox.combined
                
                return encryptedMessage?.base64EncodedString()
            } catch _ {}
        }
        
        return nil
    }
    
    func decryptWithPublicKey(text: String) -> String? {
        if let keyData = AppInfo.publicKey.data(using: .utf8),
           let data = Data(base64Encoded: text) {
            
            let key = SymmetricKey(data: keyData)
            do {
                let sealedBox = try AES.GCM.SealedBox(combined: data)
                let openedBox = try AES.GCM.open(sealedBox, using: key)
                
                return String(data: openedBox, encoding: .utf8)
            } catch _ {}
        }
        
        return nil
    }
    
    func encryptWithPrivateKey(text: String) -> String? {
        if let keyData = self.privateKey.data(using: .utf8),
           let data = text.data(using: .utf8) {
            
            let key = SymmetricKey(data: keyData)
            do {
                let sealedBox =  try AES.GCM.seal(data, using: key)
                let encryptedMessage = sealedBox.combined
                
                return encryptedMessage?.base64EncodedString()
            } catch _ {}
        }
        
        return nil
    }
    
    func decryptWithPrivateKey(text: String) -> String? {
        if let keyData = self.privateKey.data(using: .utf8),
           let data = Data(base64Encoded: text) {
            
            let key = SymmetricKey(data: keyData)
            do {
                let sealedBox = try AES.GCM.SealedBox(combined: data)
                let openedBox = try AES.GCM.open(sealedBox, using: key)
                
                return String(data: openedBox, encoding: .utf8)
            } catch _ {}
        }
        
        return nil
    }
}

//MARK: - String + AESProvider
extension String {
    
    var encrypted: String {
        AESProvider.shared.encryptWithPublicKey(text: self) ?? ""
    }
    
    var decrypted: String {
        AESProvider.shared.decryptWithPublicKey(text: self) ?? ""
    }
    
    var privateEncrypted: String {
        AESProvider.shared.encryptWithPrivateKey(text: self) ?? ""
    }
    
    var privateDecrypted: String {
        AESProvider.shared.decryptWithPrivateKey(text: self) ?? ""
    }
}
