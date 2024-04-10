//
//  SportsResponseModel.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 5.04.24.
//

import Foundation

struct SportsResponseModel: Codable {
    var data: [SportModel]
}

// TODO: Not used
struct SportDetailResponseModel: Codable {
    var data: SportModel
}

struct SportDetailEventsResponseModel: Codable {
    var data: [EventPrimaryMarketAggregate]
}
