//
//  AppUIFactory.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class AppUIFactory: AppFlowUIFactory {
    
    func makeRootViewController() -> UIViewController {
        // Show launch screen when application loads info about authintification in background
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()!
         
        return viewController
    }
}
