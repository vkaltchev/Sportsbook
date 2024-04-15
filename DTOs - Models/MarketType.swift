//
//  MarketTypeModel.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 10.04.24.
//

import Foundation

enum MarketType: String, Codable {
    case winDrawWin = "WIN_DRAW_WIN"
    case matchBetting = "MATCH_BETTING"
    case totalGoalsInMatch = "TOTAL_GOALS_IN_MATCH"
}
