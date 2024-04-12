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
    
    func fetchAndTransformSportsEvents(forSportWith id: Int) {
        loadingState = .loading
        Task {
            do {
                print("Requesting sport events data.")
                let sportEventRequest = SportsDetailEventsRequest(sportId: id)
                let response = try await APIManager().execute(
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

// TODO: Move?
extension Date {

    // TODO: refactor and move this as a helper out of Date.
    func formattedWithSuffix() -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE d'\(self.daySuffix())' MMMM"
        
        return formatter.string(from: self)
    }

    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}

