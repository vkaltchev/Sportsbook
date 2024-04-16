//
//  SportDetailsViewModel.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 11.04.24.
//

import Foundation

enum SportDetailsViewModelLoadingState {
    case loading
    case finished
    case error(APIError)
}

final class SportDetailsViewModel {
    @Published var sportsEventMarketTableModel: [SportsEventMarketSectionModel] = []
    @Published var sportModel: SportModel
    @Published var loadingState: SportDetailsViewModelLoadingState = .finished
    
    init(sportModel: SportModel) {
        self.sportModel = sportModel
        fetchAndTransformSportsEvents(forSportWith: sportModel.id)
    }
    
    /// Fires a request for Sport events and markets and transforms the result into table datasource models.
    /// Also changes the loadingState based on the request progress/result.
    /// - Parameter id: The id of the sport we're requesting the events and markets for.
    func fetchAndTransformSportsEvents(forSportWith id: Int, apiManager: APIManagerProtocol = APIManager()) {
        loadingState = .loading
        Task {
            do {
                let sportEventRequest = SportsDetailEventsRequest(sportId: id)
                let response = try await apiManager.execute(
                    request: sportEventRequest,
                    expectedType: SportDetailEventsResponseModel.self
                )
                let sportsList = response.data.data
                var sportsEventsTableModel: [SportsEventMarketSectionModel] = []
                
                sportsList.forEach { eventMarketData in
                    let sectionModel = SportsEventMarketSectionModel(dateString: eventMarketData.date.formattedWithSuffix())
                    if !sportsEventsTableModel.contains(where: { section in
                        section.dateString == sectionModel.dateString
                    }) {
                        sportsEventsTableModel.append(sectionModel)
                    }
                }
          
                sportsEventMarketTableModel = sportsEventsTableModel.map({ sectionModel in
                    var cellModelsForSection: [ConfigurableTableViewCellModel] = []
                    sportsList.forEach { eventMarketData in
                        if sectionModel.dateString == eventMarketData.date.formattedWithSuffix() {
                            cellModelsForSection.append(SportDetailsTableViewCellModel(eventMarketData: eventMarketData))
                        }
                    }
                    
                    // The separator shouldn't be visible for the last cell in the section
                    if var lastItem = (cellModelsForSection.last as? SportDetailsTableViewCellModel) {
                        lastItem.shouldShowSeparator = false
                        cellModelsForSection.removeLast()
                        cellModelsForSection.append(lastItem)
                    }
                   
                    return SportsEventMarketSectionModel(dateString: sectionModel.dateString, cellModels: cellModelsForSection)
                })
                loadingState = .finished
            } catch {
                loadingState = .error(error as! APIError)
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
