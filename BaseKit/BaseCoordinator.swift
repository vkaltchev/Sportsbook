//
//  BaseCoordinator.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 16.04.24.
//

import Foundation
import UIKit

class Coordinator {
    
    open private(set) var childCoordinators: [Coordinator] = []
    open weak var parentCoordinator: Coordinator?
    
    public init() { }
    
    /// Start The Coordinator. Override in each class.
    open func start() {
        preconditionFailure("This method needs to be overriden by the subclass.")
    }
    
    /// Coordinator work has ended - VC is about to be deinitialized.
    /// Must be called when finishing/popping/dismissing the VC.
    /// Removal from parents is handled here and each class should handle navigation action as needed(pop/dismiss etc)
    open func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    /// Adds a child coordinator to the childCoordinators array
    /// - Parameter coordinator: the coordinator to add
    open func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    /// Removes a child coordinator from the childCoordinators array
    /// - Parameter coordinator: Coordinator to be removed
    open func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
