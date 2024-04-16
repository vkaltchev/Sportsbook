//
//  SportsListCoordinator.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 16.04.24.
//

import Foundation
import UIKit


final class SportsCatalogueCoordinator: Coordinator {
    unowned private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewModel = SportsCatalogueViewModel()
        viewModel.coordinatorDelegate = self
        viewModel.fetchSportsCatalogue()
        let rootVC = SportsCatalogueViewController(viewModel: viewModel)
        navigationController.pushViewController(rootVC, animated: true)
    }
}

// **********************************
// MARK: - SportsCatalogue Delegate
// **********************************

extension SportsCatalogueCoordinator: SportsCatalogueDelegate {
    
    func showSportDetails(for model: SportModel) {
        let sportDetailsViewModel = SportDetailsViewModel(sportModel: model)
        sportDetailsViewModel.fetchAndTransformSportsEvents(forSportWith: model.id)
        let detailsVC = SportDetailsViewController(viewModel: sportDetailsViewModel)
        navigationController.pushViewController(detailsVC, animated: true)
    }
}
