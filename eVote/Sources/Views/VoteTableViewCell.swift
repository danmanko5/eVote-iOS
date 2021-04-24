//
//  VoteTableViewCell.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class VoteTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let votesCountLabel = UILabel()
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
        self.selectionStyle = .none
        
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        self.titleLabel.textColor = .label
        self.titleLabel.textAlignment = .center
        
        self.votesCountLabel.font = .preferredFont(forTextStyle: .body)
        self.votesCountLabel.textColor = .secondaryLabel
        
        self.createdByLabel.font = .preferredFont(forTextStyle: .body)
        self.createdByLabel.textColor = .secondaryLabel
        
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.votesCountLabel, self.createdByLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.setCustomSpacing(0, after: self.votesCountLabel)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        
        let stackViewPlaceholderView = UIView()
        stackViewPlaceholderView.fl_addSubview(stackView)
        stackViewPlaceholderView.layer.cornerRadius = 10
        stackViewPlaceholderView.clipsToBounds = true
        
        let shadowView = UIView()
        shadowView.layer.cornerRadius = 10
        shadowView.backgroundColor = .systemBackground
        shadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        let verticallyAlignedStackView = UIStackView(arrangedSubviews: [stackViewPlaceholderView])
        verticallyAlignedStackView.isLayoutMarginsRelativeArrangement = true
        verticallyAlignedStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        verticallyAlignedStackView.backgroundColor = .clear
        
        self.fl_addSubview(shadowView) { (view, container) -> [NSLayoutConstraint] in
            [
                view.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
            ]
        }
        
        self.fl_addSubview(verticallyAlignedStackView)
    }
    
    private func updateViews() {
        guard let vote = self.vote else { return }
        
        self.titleLabel.text = vote.title
        self.votesCountLabel.text = "\(vote.totalVotes()) Votes"
        
        let createdByString = "Created by @\(vote.username)"
        let range = (createdByString as NSString).range(of: "@\(vote.username)")

        let mutableAttributedString = NSMutableAttributedString.init(string: createdByString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range)
        self.createdByLabel.attributedText = mutableAttributedString
    }
}
