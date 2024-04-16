//
//  APIResponse.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 4.04.24.
//

import Foundation

struct APIResponse<ModelType> {
    let statusCode: Int
    let data: ModelType
    let responseHeaders: [AnyHashable: Any]

    init(statusCode: Int, data: ModelType, responseHeaders: [AnyHashable: Any] = [:]) {
        self.statusCode = statusCode
        self.data = data
        self.responseHeaders = responseHeaders
    }
}
