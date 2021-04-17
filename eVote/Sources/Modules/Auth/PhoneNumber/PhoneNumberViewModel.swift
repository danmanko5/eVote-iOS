//
//  PhoneNumberViewModel.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class PhoneNumberViewModel {
    
    private(set) var country: Country
    
    let authenticator: Authenticator
    
    var isAuthenticating: StorableObservable<Bool> {
        return self.authenticator.isAuthenticating
    }
    var countryUpdatedCallback: VoidClosure?
    
    init(authenticator: Authenticator) {
        self.authenticator = authenticator
        self.country = Country.currentCountry ?? Country(countryCode: "US", phoneExtension: "1")
    }
    
    func authenticate(phoneNumber: String, completion: @escaping  ((Result<Void, Error>) -> Void)) {
        self.authenticator.authenticate(with: phoneNumber, completion: completion)
    }
    
    func updateCountry(_ country: Country) {
        self.country = country
        self.countryUpdatedCallback?()
    }
    
    func countryCodeTitle() -> String {
        return "+\(self.country.phoneExtension)"
    }
    
    func displayableNumber(_ phone: String) -> String {
        return "+" + self.country.phoneExtension + phone
    }
    
    func validateNumber(_ number: String) -> Bool {
        let wholeNumber = self.country.phoneExtension + number
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: wholeNumber, options: [], range: NSMakeRange(0, wholeNumber.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == wholeNumber.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func cancel() {
        self.authenticator.cancel()
    }
    
}
