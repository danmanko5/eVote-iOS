//
//  SettingsView+Data.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

extension SettingsView {
    
    enum Data {
        enum Section {
            
            enum General {
            }
            
            struct Link {
                let url: URL
                let displayObject: SettingsView.DisplayObject.General
            }
            
            enum Action {
                case logout(SettingsView.DisplayObject.Action)
                case delete(SettingsView.DisplayObject.Action)
            }
            
            case general([General])
            case links([Link])
            case actions([Action])
        }
    }
}
