//
//  HorizontalSeparatorView.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class HorizontalSeparatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .separator
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
