//
//  SportViewModel.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 14.04.24.
//

import Foundation

enum SportCatalogueViewModelLoadingState {
    case loading
    case finished
    case error(APIError)
}

final class SportsCatalogueViewModel {
    @Published var cellModels: [ConfigurableTableViewCellModel] = []
    @Published var sportsCatalogue: [SportModel] = []
    @Published var loadingState: SportCatalogueViewModelLoadingState = .finished
    var coordinatorDelegate: SportsCatalogueDelegate?
    
    /// Fetch and transform sports list into cell models
    /// - Parameter apiManager: The APIMaanager instance to be used for firing the request.  Instance other than the default one may mainly be needed for tests.
    func fetchSportsCatalogue(apiManager: APIManagerProtocol = APIManager()) {
        loadingState = .loading
        
        Task {
            do {
                let sportsRequest = SportsRequest()
                let response = try await apiManager.execute(
                    request: sportsRequest,
                    expectedType: SportsResponseModel.self
                )
                
                let sportsList = response.data.data
                cellModels = []
                // Create Cell Models array
                cellModels = sportsList.map { sport in
                    return CatalogTableViewCellModel(
                        sportName: sport.name,
                        shouldShowSeparator: sportsList.last != sport
                    )
                }
                sportsCatalogue = sportsList
                loadingState = .finished
            } catch {
                if let error = error as? APIError {
                    loadingState = .error(error)
                } else {
                    loadingState = .error(APIError.other(error))
                }
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Implementation of SportsCatalogueDelegate protocol. Used for the Coordinator delegation
    /// - Parameter model: Sport to show the market details for
    func showSportDetails(for model: SportModel) {
        guard let coordinatorDelegate = coordinatorDelegate else {
            print("Critical error: No coordinator delegate in SportsCatalogueViewModel.")
            return
        }
        coordinatorDelegate.showSportDetails(for: model)
    }
    
}

/// Protocol for the coordinator delegate
protocol SportsCatalogueDelegate: AnyObject {
    func showSportDetails(for model: SportModel)
}
