//
//  RequestManager.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 4.04.24.
//

import Foundation

typealias HTTPHeaders = [String: String]

protocol APIManagerProtocol {

    /**
     * Handles HTTP requests for specific endpoint.
     *
     *  - Parameters:
     *      - endpoint: the relative address for the endpoing.
     *      - the HTTP method that should be used (e.g. GET, POST, PUT, etc.)
     *      - headers: a list of key-value pairs representing each HTTP header to be passed.
     *      - body: the method payload
     *      - type: the expected `Decodable` type to be returned from the request.
     *      - authorized: determines whether header bearer authorisation should be used.
     *      - refreshTokenIfNecessary: if the request fails with error 401, it will call the refreshToken method.
     *
     *  - Returns:
     *      A `NetworkResult` that contains the `statusCode` and the expected response type in the `data` property.
     */
    func execute<ModelType: Decodable>(
        request: any APIRequest,
        expectedType: ModelType.Type
    ) async throws -> APIResponse<ModelType>
}


struct APIManager: APIManagerProtocol {
    
    private weak var urlSession: URLSession?
//    private var authHandler: NetworkAuthHandler?
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter
    }()

    init(
        urlSession: URLSession = URLSession.shared
    ) {
        self.urlSession = urlSession
    }

    func execute<ModelType: Decodable>(
        request: any APIRequest,
        expectedType: ModelType.Type = String.self
    ) async throws -> APIResponse<ModelType> {

        guard let urlSession = self.urlSession else {
            throw APIError.invalidSession
        }
        
        let urlRequest = try request.asURLRequest()

        // do request
        let (data, response) = try await urlSession.data(for: urlRequest)

        // process response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
            throw APIError.failure(data, httpResponse)
        }
        
        if expectedType == String.self {
            let text = data.count == 0 ? "" : String(decoding: data, as: UTF8.self)
            return APIResponse(statusCode: httpResponse.statusCode, data: text as! ModelType, responseHeaders: httpResponse.allHeaderFields)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // TODO: explain why it is needed
        let object = try decoder.decode(expectedType, from: data)
        return APIResponse(statusCode: httpResponse.statusCode, data: object, responseHeaders: httpResponse.allHeaderFields)
    }
}
