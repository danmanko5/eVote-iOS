//
//  SettingsView+DisplayObjects.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

extension SettingsView {
    
    enum DisplayObject {
        
        struct General {
            let title: String
        }
        
        struct Action {
            let title: String
            let isDestructive: Bool
        }
    }
}
