//
//  APIResponse.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 4.04.24.
//

import Foundation

struct APIResponse<ModelType> {
    public let statusCode: Int
    public let data: ModelType
    public let responseHeaders: [AnyHashable: Any]

    public init(statusCode: Int, data: ModelType, responseHeaders: [AnyHashable: Any] = [:]) {
        self.statusCode = statusCode
        self.data = data
        self.responseHeaders = responseHeaders
    }
}
