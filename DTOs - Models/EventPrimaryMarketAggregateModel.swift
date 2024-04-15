//
//  EventPrimaryMarketAggregate.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 10.04.24.
//

import Foundation

struct EventPrimaryMarketAggregate: Codable {
    let id: UUID
    let name: String
    let date: Date
    let primaryMarket: Market
}

extension EventPrimaryMarketAggregate: Equatable {
    static func == (lhs: EventPrimaryMarketAggregate,
                    rhs: EventPrimaryMarketAggregate) -> Bool {
        return lhs.id == rhs.id
    }
}
