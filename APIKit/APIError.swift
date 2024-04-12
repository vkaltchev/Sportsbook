//
//  APIError.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 12.04.24.
//

import Foundation

enum APIError: Error {

    case invalidSession
    case invalidURL
    case invalidResponse
    case failure(Data, HTTPURLResponse)
    case invalidData
    case failedDecoding
    case other(Error)
}

