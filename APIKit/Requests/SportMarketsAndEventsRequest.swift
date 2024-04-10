//
//  SportMarketsAndEventsRequest.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 10.04.24.
//

import Foundation

struct SportsDetailEventsRequest: APIRequest {
    let sportId: Int
    let path: String
    var baseUrl: String = Config.default.baseUrl
    var method: HTTPMethod = .get
    var requiresAuthorization: Bool = true
    var headers: [String : String] = Config.default.headers
    
    init(sportId: Int) {
        self.sportId = sportId
        self.path =  "/sports/\(sportId)/events"
    }
}
