//
//  VoteTableViewCell.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class VoteTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let createdByLabel = UILabel()
    
    var vote: Vote? {
        didSet {
            self.updateViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.titleLabel.font = .preferredFont(forTextStyle: .title2)
        self.titleLabel.textColor = .label
        
        self.createdByLabel.font = .preferredFont(forTextStyle: .body)
        self.createdByLabel.textColor = .secondaryLabel
        
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.createdByLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        self.fl_addSubview(stackView)
    }
    
    private func updateViews() {
        guard let vote = self.vote else { return }
        
        self.titleLabel.text = vote.title
        self.createdByLabel.text = "Created by \(vote.username)"
    }
}
