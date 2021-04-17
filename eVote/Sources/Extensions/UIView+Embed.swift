//
//  UIView+Embed.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

extension UIView {
    
    typealias LayoutConstraintsSetupClosure = (UIView, UIView) -> [NSLayoutConstraint]
    
    static var fl_constraintsCoverFull: LayoutConstraintsSetupClosure = { (view, container) in
        [
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ]
    }
    
    static var fl_constraintsCoverToLayoutMargins: LayoutConstraintsSetupClosure = { (view, container) in
        [
            view.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
            view.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor)
        ]
    }
    
    static var fl_constraintsCenterVerticallyAndStickHorizontallyToLayoutMargins: LayoutConstraintsSetupClosure = { (view, container) in
        [
            view.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ]
    }
    
    static var fl_constraintsCenter: LayoutConstraintsSetupClosure = { (view, container) in
        [
            view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ]
    }
    
    static var fl_constraintsHorizontallyCenteredAtBottomMargin: LayoutConstraintsSetupClosure = { (view, container) in
        [
            view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            view.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor)
        ]
    }
    
    static var fl_constraintsAtTop: LayoutConstraintsSetupClosure = { (view, container) in
        [
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.topAnchor.constraint(equalTo: container.topAnchor)
        ]
    }
    
    static var fl_constraintsAtBottom: LayoutConstraintsSetupClosure = { (view, container) in
        [
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ]
    }
    
    static var fl_constraintsAtTopLayoutMargins: LayoutConstraintsSetupClosure = { (view, container) in
        [
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            view.bottomAnchor.constraint(lessThanOrEqualTo: container.layoutMarginsGuide.bottomAnchor)
        ]
    }
    
    static var fl_constraintsAtBottomLayoutMargins: LayoutConstraintsSetupClosure = { (view, container) in
        [
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.topAnchor.constraint(greaterThanOrEqualTo: container.layoutMarginsGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor)
        ]
    }
    
    func fl_addSubview(_ view: UIView, layoutConstraints: LayoutConstraintsSetupClosure = UIView.fl_constraintsCoverFull) {
        guard view.superview == nil else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        let constraints = layoutConstraints(view, self)
        NSLayoutConstraint.activate(constraints)
    }
}
