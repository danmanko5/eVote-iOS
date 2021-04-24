//
//  VoteTableFooterView.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class VoteTableFooterView: UIView {
    
    private let voteButton = FLButton()
    private let resultsButton = UIButton()
    
    var hasVoted: Bool = false {
        didSet {
            self.resultsButton.isHidden = !self.hasVoted
            self.voteButton.setTitle(self.hasVoted ? "Voted" : "Vote", for: .normal)
        }
    }
    var canVote: Bool = false {
        didSet {
            self.voteButton.isEnabled = self.canVote
        }
    }
    
    var onVote: VoidClosure?
    var onResult: VoidClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.voteButton.setTitle("Vote", for: .normal)
        self.voteButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.voteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.voteButton.addTarget(self, action: #selector(self.votePressed), for: .touchUpInside)
        
        self.resultsButton.setTitle("See results", for: .normal)
        self.resultsButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.resultsButton.setTitleColor(UIColor.systemBlue, for: .normal)
        self.resultsButton.addTarget(self, action: #selector(self.resultsPressed), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [self.voteButton, self.resultsButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 40, left: 20, bottom: 20, right: 20)
        
        self.fl_addSubview(stackView)
    }
    
    @objc private func votePressed() {
        self.onVote?()
    }
    
    @objc private func resultsPressed() {
        self.onResult?()
    }
}
