//
//  TextFieldWithInsets.swift
//  eVote
//
//  Created by Danylo Manko on 24.04.2021.
//

import UIKit

final class TextFieldWithInsets: UITextField {
    
    let insets: UIEdgeInsets
    
    init(insets: UIEdgeInsets) {
        self.insets = insets
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.insets)
    }
}
