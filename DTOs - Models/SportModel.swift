//
//  SportModel.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 5.04.24.
//

import Foundation

struct SportModel: Codable {
    let id: Int
    let name: String
}

extension SportModel: Equatable {
    static func == (lhs: SportModel,
                    rhs: SportModel) -> Bool {
        return lhs.id == rhs.id
        && lhs.name == rhs.name
    }
}






