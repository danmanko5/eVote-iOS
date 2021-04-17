//
//  UIViewController+Embed.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

extension UIViewController {
    
    func fl_embed(viewController: UIViewController, layoutConstraints: UIView.LayoutConstraintsSetupClosure = UIView.fl_constraintsCoverFull) {
        
        self.addChild(viewController)
        viewController.view.preservesSuperviewLayoutMargins = true
        self.view.fl_addSubview(viewController.view, layoutConstraints: layoutConstraints)
        viewController.didMove(toParent: self)
    }
    
    func fl_unembedSelf() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
