//
//  SettingsView+Reusables.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

extension SettingsView {
    
    enum Reusables {
        enum CellType: CaseIterable {
            case general
            case action
        }
    }
}

extension SettingsView.Reusables.CellType {
    
    var cellType: AnyClass {
        switch self {
        case .general:
            return SettingsGeneralCell.self
        case .action:
            return SettingsActionCell.self
        }
    }
    
    var reuseIdentifier: String {
        return "\(self.cellType)"
    }
    
    var height: CGFloat {
        return 50
    }
}
