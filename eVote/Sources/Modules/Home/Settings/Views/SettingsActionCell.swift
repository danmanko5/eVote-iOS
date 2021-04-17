//
//  SettingsActionCell.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class SettingsActionCell: UICollectionViewCell {
    
    var displayObject: SettingsView.DisplayObject.Action? {
        didSet {
            self.label.text = self.displayObject?.title
            self.label.textColor = (self.displayObject?.isDestructive ?? false) ? UIColor.systemRed : .label
        }
    }
    var isFirst: Bool {
        get {
            return !self.topSeparatorView.isHidden
        }
        set {
            self.topSeparatorView.isHidden = !newValue
        }
    }
    var isLast: Bool {
        get {
            return (self.bottomFullWidthConstraint?.isActive ?? false)
        }
        set {
            self.bottomFullWidthConstraint?.isActive = newValue
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.updateBackgroundColor()
        }
    }
    
    private let label: UILabel
    private let topSeparatorView: UIView
    private let bottomSeparatorView: UIView
    private var bottomFullWidthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        self.label = UILabel()
        self.topSeparatorView = HorizontalSeparatorView()
        self.bottomSeparatorView = HorizontalSeparatorView()
        
        super.init(frame: frame)
        
        self.preservesSuperviewLayoutMargins = true
        
        self.label.font = .preferredFont(forTextStyle: .body)
        self.label.textAlignment = .center
        self.fl_addSubview(self.label, layoutConstraints: UIView.fl_constraintsCenterVerticallyAndStickHorizontallyToLayoutMargins)
        
        self.fl_addSubview(self.topSeparatorView) { (view, container) -> [NSLayoutConstraint] in
            [
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                view.topAnchor.constraint(equalTo: container.topAnchor)
            ]
        }
        self.fl_addSubview(self.bottomSeparatorView) { (view, container) -> [NSLayoutConstraint] in
            [
                view.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor).fl_withPriority(.defaultHigh),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ]
        }
        
        self.bottomFullWidthConstraint = self.bottomSeparatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        
        self.updateBackgroundColor()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateBackgroundColor() {
        self.backgroundColor = self.isHighlighted ? UIColor.secondarySystemBackground : .systemBackground
    }
}
