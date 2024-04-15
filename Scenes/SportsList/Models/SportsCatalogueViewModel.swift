//
//  SportViewModel.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 14.04.24.
//

import Foundation

protocol SportsCatalogueDelegate {
    func showSportDetails(for model: SportModel)
}

enum SportViewModelLoadingState {
    case loading
    case finished
    case error(APIError)
}

final class SportsCatalogueViewModel {
    @Published var cellModels: [ConfigurableTableViewCellModel] = []
    @Published var sportsCatalogue: [SportModel] = []
    @Published var loadingState: SportViewModelLoadingState = .finished
    
    var coordinatorDelegate: SportsCatalogueDelegate?
    
    init() {
        fetchSportsCatalogue()
    }
    
    func fetchSportsCatalogue() {
        loadingState = .loading
        
        Task {
            do {
                let sportsRequest = SportsRequest()
                let response = try await APIManager().execute(
                    request: sportsRequest,
                    expectedType: SportsResponseModel.self
                )
                let sportsList = response.data.data
                cellModels = []
                cellModels = sportsList.map { sport in
                    return CatalogTableViewCellModel(
                        sportName: sport.name,
                        shouldShowSeparator: sportsList.last != sport
                    )
                }
                sportsCatalogue = sportsList
                loadingState = .finished
            } catch {
                loadingState = .error(error as! APIError)
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func showSportDetails(for model: SportModel) {
        coordinatorDelegate?.showSportDetails(for: model)
    }
    
}
