//
//  SportsRequest.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 5.04.24.
//

import Foundation

struct SportsRequest: APIRequest {
    var baseUrl: String = APIConfig.default.baseUrl
    var path: String = "/sports"
    var method: HTTPMethod = .get
    var requiresAuthorization: Bool = true
    var headers: [String : String] = APIConfig.default.headers
}

struct SportsDetailRequest: APIRequest {
    let sportId: Int
    let path: String
    var baseUrl: String = APIConfig.default.baseUrl
    var method: HTTPMethod = .get
    var requiresAuthorization: Bool = true
    var headers: [String : String] = APIConfig.default.headers
    
    init(sportId: Int) {
        self.sportId = sportId
        self.path =  "/sports/\(sportId)"
    }
}
