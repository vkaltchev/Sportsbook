//
//  SportDetailsTableViewCellModel.swift
//  SportsbookTests
//
//  Created by Valentin Kalchev  on 16.04.24.
//

import Foundation
import UIKit

struct SportDetailsTableViewCellModel: ConfigurableTableViewCellModel {
    
    let eventMarketData: EventPrimaryMarketAggregate
    var shouldShowSeparator: Bool = true
    var runners: [RunnerType] {
        eventMarketData.primaryMarket.runners
    }
    var homeTeamName: String {
        orderedTeamNames(from: eventMarketData.name)[0]
    }
    var awayTeamName: String {
        orderedTeamNames(from: eventMarketData.name)[1]
    }
    var marketName: String {
        eventMarketData.primaryMarket.displayName
    }
    
    var cellType: UITableViewCell.Type {
        SportDetailsTableViewCell.self
    }
}

extension SportDetailsTableViewCellModel {
    
    // Unfortunately the TOTAL_GOALS_IN_MATCH Market model doesn't provide a clean way to get the team names.
    // This is prone to braking the app if the string format is changed and will best be improved with an API change.
    // For now we'll also be using this as a source for Home and Away teams, though we can assume that we can also get that information also from the array of runners in the rest of the Market models.
    func orderedTeamNames(from matchName: String) -> [String] {
        
        // the match betting market uses "vs" as separator, while the other use "v"
        let teamNames = matchName.components(separatedBy: " vs ")
        return teamNames.count > 1 ? teamNames : matchName.components(separatedBy: " v ")
    }
}
