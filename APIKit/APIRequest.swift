//
//  APIRequest.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 4.04.24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // add other methods
}

protocol APIRequest {
//    associatedtype ResponseType: Decodable
    var baseUrl: String { get } // move this elsewhere
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }

    var requiresAuthorization: Bool { get }

}
extension APIRequest {
    func asURL() throws -> URL {
        guard let url = URL(string: baseUrl) else {
            throw APIError.invalidURL
        }

        return url.appendingPathComponent(path)
    }
}

extension APIRequest {
    func asURLRequest() throws -> URLRequest {
        try urlRequest()
    }

    func urlRequest() throws -> URLRequest {
        guard let url = URL(string: Config.default.baseUrl + path) else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = Config.default.requestTimeout
        urlRequest.httpMethod = method.rawValue
        let headers = buildHeaders(headers, authorized: requiresAuthorization)
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }
    
    func buildHeaders(_ headers: HTTPHeaders, authorized: Bool) -> HTTPHeaders {
        var requestHeaders: HTTPHeaders = [:]
        for (key, value) in headers {
            requestHeaders[key] = value
        }
        
        if authorized {
            requestHeaders["Authorization"] = "Bearer \(Config.default.authToken)" // hardcoded for now TODO: extend with authorization logic and types.
        }
        return requestHeaders
    }
}
