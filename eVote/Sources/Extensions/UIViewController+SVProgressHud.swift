//
//  UIViewController+SVProgressHud.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    
    @objc func showProgressIndicatorDialog() {
        let view = self.navigationController?.view ?? self.view
        
//        SVProgressHUD.setDefaultMaskType(.black)
//        SVProgressHUD.setContainerView(view)
//        SVProgressHUD.show()
    }
    
    @objc func dismissProgressIndicatorDialog() {
//        SVProgressHUD.dismiss()
    }
}
