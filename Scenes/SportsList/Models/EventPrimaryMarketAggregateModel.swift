//
//  EventPrimaryMarketAggregate.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 10.04.24.
//

import Foundation

struct EventPrimaryMarketAggregate: Codable {
    let id: String // TODO: make UUID
    let name: String
    let date: Date
    let primaryMarket: Market
}

