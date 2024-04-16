//
//  RequestManager.swift
//  Sportsbook
//
//  Created by Valentin Kalchev  on 4.04.24.
//

import Foundation

// TODO: A lot can be done to improve the APIKit. This is a basic implementation to start with
// Add better error handling. Add Environment manager. Add mock/test environment. Add logging with levels or configurable based on environment or other setting.

typealias HTTPHeaders = [String: String]

protocol APIManagerProtocol {
    func execute<ModelType: Decodable>(
        request: any APIRequest,
        expectedType: ModelType.Type
    ) async throws -> APIResponse<ModelType>
}

struct APIManager: APIManagerProtocol {
    
    private weak var urlSession: URLSession?
    
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
    
    /// Executes a Request with URLSession and returns an APIResponse with the expected <ModelType>
    /// - Parameters:
    ///   - request: Request instance
    ///   - expectedType: response model type expected to be returned
    /// - Returns: APIResponse instance with data of the expected ModelType
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
        decoder.dateDecodingStrategy = .iso8601 // to be able to parse the date fields
        do {
            let object = try decoder.decode(expectedType, from: data)
            return APIResponse(statusCode: httpResponse.statusCode, data: object, responseHeaders: httpResponse.allHeaderFields)
        } catch {
            throw APIError.failedDecoding
        }
    }
}
