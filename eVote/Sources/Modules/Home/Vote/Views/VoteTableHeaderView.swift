//
//  VoteTableHeaderView.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class VoteTableHeaderView: UIView {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    var vote: Vote? {
        didSet {
            self.updateViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.titleLabel.font = .preferredFont(forTextStyle: .title2)
        self.titleLabel.textColor = .label
        self.titleLabel.numberOfLines = 0
        
        self.descriptionLabel.font = .preferredFont(forTextStyle: .body)
        self.descriptionLabel.textColor = .secondaryLabel
        self.descriptionLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        self.fl_addSubview(stackView)
    }
    
    private func updateViews() {
        guard let vote = self.vote else { return }
        
        self.titleLabel.text = vote.title
        self.descriptionLabel.text = vote.description
    }
}
