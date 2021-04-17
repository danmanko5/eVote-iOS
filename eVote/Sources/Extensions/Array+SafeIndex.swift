//
//  Array+SafeIndex.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

extension Array {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
