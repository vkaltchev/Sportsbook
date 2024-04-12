//
//  Market.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 10.04.24.
//

import Foundation

struct Market: Codable {

    let id: String
    let type: MarketType
    let name: String
    // TODO: Discuss the protocol
    let runners: [RunnerType]
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // TODO: check this
        if let runners = try? container.decode(Array<WDWMatchRunner>.self, forKey: .runners) {
            self.runners = runners
        } else if let runners = try? container.decode(Array<TotalGoalsInMatchRunner>.self, forKey: .runners) {
            self.runners = runners
        } else {
            fatalError()
        }

        let type = try container.decode(MarketType.self, forKey: .type)
        let name = try container.decode(String.self, forKey: .name)
        let id = try container.decode(String.self, forKey: .id)
        self.type = type
        self.name = name
        self.id = id
    }
}

