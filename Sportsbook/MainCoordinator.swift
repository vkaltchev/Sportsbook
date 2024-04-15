//
//  MainCoordinator.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 14.04.24.
//

import UIKit

class MainCoordinator: Coordinator {
    
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        super.init()
        
        let navigationController =  UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let sportsCatalogCoordinator = SportsCatalogueCoordinator(navigationController: navigationController)
        addChildCoordinator(sportsCatalogCoordinator)
    }
    
    override func start() {
        childCoordinators.first?.start()
    }
}
