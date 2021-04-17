//
//  VoteOptionTableViewCell.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class VoteOptionTableViewCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let indicatorView = UIView()
    
    var option: VoteOption? {
        didSet {
            self.updateViews()
        }
    }
    
    var isOptionSelected: Bool = false {
        didSet {
            self.indicatorView.backgroundColor = self.isOptionSelected ? .systemBlue : .white
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
        
        self.nameLabel.font = .preferredFont(forTextStyle: .body)
        self.nameLabel.textColor = .label
        self.nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.indicatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.indicatorView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.indicatorView.layer.borderWidth = 2
        self.indicatorView.layer.borderColor = UIColor.systemBlue.cgColor
        self.indicatorView.layer.cornerRadius = 10
        
        let stackView = UIStackView(arrangedSubviews: [self.nameLabel, self.indicatorView])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        self.fl_addSubview(stackView)
    }
    
    private func updateViews() {
        guard let option = self.option else { return }
        
        self.nameLabel.text = option.name
    }
}

