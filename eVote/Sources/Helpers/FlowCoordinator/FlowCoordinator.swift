//
//  FlowCoordinator.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

protocol FlowCoordinator: class {
    var rootViewController: UIViewController { get }
    var childFlowCoordinators: [FlowCoordinator] { get set }
    func install()
}

extension FlowCoordinator {
    
    func addChildFlowCoordinator(_ childFlowCoordinator: FlowCoordinator) {
        guard !self.childFlowCoordinators.contains(where: { $0 === childFlowCoordinator }) else { return }
        self.childFlowCoordinators.append(childFlowCoordinator)
        childFlowCoordinator.install()
    }
    
    func removeChildFlowCoordinator(_ childFlowCoordinator: FlowCoordinator) {
        self.childFlowCoordinators = self.childFlowCoordinators.filter { $0 !== childFlowCoordinator }
    }
}
