//
//  UINavigationBar+Style.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

extension UINavigationBar {
    
    func makeTransparent() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
    func makeOpaque() {
        self.setBackgroundImage(nil, for: .default)
        self.shadowImage = nil
        self.isTranslucent = false
    }
}
