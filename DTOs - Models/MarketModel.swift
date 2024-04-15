//
//  Market.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 10.04.24.
//

import Foundation

struct Market: Codable {

    let id: UUID
    let type: MarketType
    let name: String
    let runners: [RunnerType]
    
    /// There's a mismatch between the design and the market name in the model. Thus remapping.
    /// In the Rugby league MATCH_BETTING has a long name "Regular Time Match Odds" which is braking the design a bit. Nevertheless, I'm keeping it as it is.
    var displayName: String {
        switch type {
        case .matchBetting:
            return self.name
        case .totalGoalsInMatch:
            return "Goals in Match"
        case .winDrawWin:
            return self.name
        }
    }
}

extension Market {
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case runners
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        var runnersContainer = container.nestedUnkeyedContainer(forKey: .runners)
        for runner in self.runners {
            try runnersContainer.encode(runner)
        }
    }
    
    /// API could return different types of Runners, thus the need for custom decoding and generics.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let runners = try? container.decode(Array<WDWMatchRunner>.self, forKey: .runners) {
            self.runners = runners
        } else if let runners = try? container.decode(Array<TotalGoalsInMatchRunner>.self, forKey: .runners) {
            self.runners = runners
        } else {
            fatalError()
        }

        let type = try container.decode(MarketType.self, forKey: .type)
        let name = try container.decode(String.self, forKey: .name)
        let id = try container.decode(UUID.self, forKey: .id)
        self.type = type
        self.name = name
        self.id = id
    }
}

