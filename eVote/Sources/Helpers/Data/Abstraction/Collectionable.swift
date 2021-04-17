//
//  Collectionable.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

protocol Collectionable {
    var id: Identifier { get }
    
    static var collectionName: String { get }
}
