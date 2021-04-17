//
//  FlowCoordinatorsProvider.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import Foundation

final class FlowCoordinatorsProvider {
    
    let uiFactoriesProvider: UIFactoriesProvider
    
    private(set) lazy var appFlowCoordinator: AppFlowCoordinator = {
        let uiFactory = self.uiFactoriesProvider.makeAppUIFactory()
        let flowCoordinator = AppFlowCoordinator(uiFactory: uiFactory,
                                                 flowCoordinatorsProvider: self,
                                                 authenticationStateProvider: self.authenticationStateProvider)
        return flowCoordinator
    }()
    let authenticationStateProvider: AuthenticationStateProvider
    
    init(uiFactoriesProvider: UIFactoriesProvider,
         authenticationStateProvider: AuthenticationStateProvider) {
        
        self.uiFactoriesProvider = uiFactoriesProvider
        self.authenticationStateProvider = authenticationStateProvider
    }
}

extension FlowCoordinatorsProvider: AppChildFlowCoordinatorsProvider {
    func makeHomeFlowCoordinator(user: User) -> HomeFlowCoordinator {
        let uiFactory = self.uiFactoriesProvider.makeHomeUIFactory()
        let flowCoordinator = HomeFlowCoordinator(uiFactory: uiFactory, user: user)
        
        return flowCoordinator
    }
    
    func makeAuthFlowCoordinator() -> AuthFlowCoordinator {
        let uiFactory = self.uiFactoriesProvider.makeAuthUIFactory()
        let flowCoordinator = AuthFlowCoordinator(uiFactory: uiFactory, authenticationStateProvider: self.authenticationStateProvider)
        
        return flowCoordinator
    }
    
    func makeProfileSetupFlowCoordinator(userId: Identifier) -> ProfileSetupFlowCoordinator {
        let uiFactory = self.uiFactoriesProvider.makeProfileSetupUIFactory()
        let flowCoordinator = ProfileSetupFlowCoordinator(uiFactory: uiFactory, userId: userId)
        
        return flowCoordinator
    }
}
