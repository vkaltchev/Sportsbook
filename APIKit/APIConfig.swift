//
//  APIConfig.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 4.04.24.
//

import Foundation

struct Config {

    public static let `default` = Config()

    let baseUrl: String = "http://localhost:8080" // move out from here eventually
    let authToken: String = "ewogICAibmFtZSI6ICJHdWVzdCIKfQ==" // harcoded for now. TODO: Extend with authorization logic in future
    let requestTimeout: TimeInterval = 30
    let headers: HTTPHeaders = ["Content-Type": "application/json; charset=utf-8"]
}
