//
//  SettingsViewModel.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class SettingsViewModel {
    
    let user: User
    let urlHandler: URLHandler
    let logoutProvider: AuthenticationLogoutProvider
    let userDeletionProvider: AuthenticationUserDeletionProvider
    
    private let sections: [SettingsView.Data.Section]
    
    init(user: User,
         urlHandler: URLHandler,
         logoutProvider: AuthenticationLogoutProvider,
         userDeletionProvider: AuthenticationUserDeletionProvider) {
        self.user = user
        self.urlHandler = urlHandler
        self.logoutProvider = logoutProvider
        self.userDeletionProvider = userDeletionProvider
        
        var links: [SettingsView.Data.Section.Link] = []
        if let privacyURL = AppInfo.privacyURL {
            let displayObject = SettingsView.DisplayObject.General(title: "Privacy Policy")
            let link = SettingsView.Data.Section.Link(url: privacyURL,
                                                      displayObject: displayObject)
            links.append(link)
        }
        
        if let termsURL = AppInfo.termsURL {
            let displayObject = SettingsView.DisplayObject.General(title: "Terms of Use")
            let link = SettingsView.Data.Section.Link(url: termsURL,
                                                      displayObject: displayObject)
            links.append(link)
        }
        
        let actions: [SettingsView.Data.Section.Action] = [
            .logout(SettingsView.DisplayObject.Action(title: "Logout", isDestructive: false)),
            .delete(SettingsView.DisplayObject.Action(title: "Delete", isDestructive: true))
        ]
        
        self.sections = [
            .links(links),
            .actions(actions)
        ]
    }
}

extension SettingsViewModel {
    
    func numberOfSections() -> Int {
        return self.sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        let section = self.sections[section]
        switch section {
        case .general(let items):
            return items.count
            
        case .links(let items):
            return items.count
            
        case .actions(let items):
            return items.count
        }
    }
    
    func cellTypeForItem(at indexPath: IndexPath) -> SettingsView.Reusables.CellType? {
        let section = self.sections[indexPath.section]
        switch section {
        case .general,
             .links:
            return .general
            
        case .actions:
            return .action
        }
    }
    
    func generalDisplayObject(at indexPath: IndexPath) -> SettingsView.DisplayObject.General? {
        let section = self.sections[indexPath.section]
        switch section {
        case .general:
            return nil
        case .links(let items):
            return items[indexPath.item].displayObject
        case .actions:
            return nil
        }
    }
    
    func actionDisplayObject(at indexPath: IndexPath) -> SettingsView.DisplayObject.Action? {
        let section = self.sections[indexPath.section]
        switch section {
        case .general,
             .links:
            return nil
            
        case .actions(let items):
            let item = items[indexPath.item]
            switch item {
            case .logout(let displayObject):
                return displayObject
            case .delete(let displayObject):
                return displayObject
            }
        }
    }
    
    func selectItem(at indexPath: IndexPath) {
        let section = self.sections[indexPath.section]
        switch section {
        case .general:
            break
        case .links(let items):
            let item = items[indexPath.item]
            self.urlHandler.open(item.url)
        case .actions(let items):
            let item = items[indexPath.item]
            switch item {
            case .logout:
                self.logoutProvider.logout()
            case .delete:
                self.userDeletionProvider.deleteUser(completion: { _ in })
            }
        }
    }
}

