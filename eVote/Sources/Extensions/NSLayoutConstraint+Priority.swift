//
//  NSLayoutConstraint+Priority.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

extension NSLayoutConstraint {
    
    func fl_withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
