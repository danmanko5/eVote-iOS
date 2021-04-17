//
//  VoteResultTableViewCell.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class VoteResultTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let resultView = UIView()
    private let resultLabel = UILabel()
    
    private var resultViewWidthConstraint: NSLayoutConstraint?
    
    var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    var rate: Int = 0 {
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
        self.titleLabel.font = .preferredFont(forTextStyle: .body)
        self.titleLabel.textColor = .label
        
        self.resultView.backgroundColor = .systemBlue
        self.resultView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.resultViewWidthConstraint = self.resultView.widthAnchor.constraint(equalToConstant: 0)
        self.resultViewWidthConstraint?.isActive = true
        
        self.resultLabel.font = .preferredFont(forTextStyle: .footnote)
        self.resultLabel.textColor = .white
        
        self.resultView.fl_addSubview(self.resultLabel, layoutConstraints: UIView.fl_constraintsCenter)
        
        let resultViewStackView = UIStackView(arrangedSubviews: [self.resultView, UIView()])
        resultViewStackView.axis = .horizontal
        resultViewStackView.layer.borderWidth = 1
        resultViewStackView.layer.borderColor = UIColor.systemBlue.cgColor
        
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, resultViewStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        self.fl_addSubview(stackView)
    }
    
    private func updateViews() {
        self.resultLabel.text = "\(self.rate)%"
        
        self.resultViewWidthConstraint?.constant = max(50, (UIScreen.main.bounds.width - 40) / 100 * CGFloat(self.rate))
    }
}
