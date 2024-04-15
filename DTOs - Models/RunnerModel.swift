//
//  Runner.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 10.04.24.
//

import Foundation

protocol RunnerType: Codable {
    var id: UUID { get set }
    var odds: Odds { get set }
    var marketType: MarketType { get set }
}

struct WDWMatchRunner: RunnerType, Codable {
    let name: String
    var id: UUID
    var odds: Odds
    var marketType: MarketType
}

struct TotalGoalsInMatchRunner: RunnerType, Codable {
    let totalGoals: Int
    var id: UUID
    var odds: Odds
    var marketType: MarketType
}
