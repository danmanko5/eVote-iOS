//
//  FLButton.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class FLButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = self.isEnabled ? UIColor.systemBlue : UIColor.systemGray
        }
    }
    
    private func setupView() {
        self.layer.cornerRadius = 10
        self.backgroundColor = .systemBlue
        self.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
