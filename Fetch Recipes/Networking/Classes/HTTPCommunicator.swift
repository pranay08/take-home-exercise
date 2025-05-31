//
//  HTTPCommunicator.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

final class HTTPCommunicator {
    private let server: Server
    private let requester: URLRequestable
    
    // MARK: - Object Lifecycle
    
    init(server: Server = .dev, requester: URLRequestable = URLSession.shared) {
        self.server = server
        self.requester = requester
    }
    
    // MARK: - Private
    
    private func buildURLRequest(from request: HTTPRequestable) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = server.scheme
        components.host = server.host
        components.port = server.port
        components.path = request.path
        if let parameters = request.queryParameters {
            let items = parameters.reduce(into: [URLQueryItem]()) { partialResult, pair in
                partialResult.append(.init(
                    name: pair.key,
                    value: pair.value
                ))
            }
            components.queryItems = items
        }
        
        guard let url = components.url else {
            throw NetworkingError.badRequest
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        var fields: [String: String] = [
            "Accepts": "application/json"
        ]
        if let additionaHeaderFields = request.additionaHeaderFields {
            additionaHeaderFields.forEach { pair in
                fields[pair.key] = pair.value
            }
        }
        urlRequest.allHTTPHeaderFields = fields
        return urlRequest
    }
}

// MARK: - HTTPCommunicable

extension HTTPCommunicator: HTTPCommunicable {
    func send<ResponseType>(
        request: any HTTPRequestable,
        decoder: JSONDecoder
    ) async throws -> ResponseType where ResponseType : Decodable {
        let urlRequest = try buildURLRequest(from: request)
        let (data, response) = try await requester.data(for: urlRequest)
        guard let httpURLResponse = response as? HTTPURLResponse else {
            throw NetworkingError.badResponse
        }
        let statusCode = httpURLResponse.statusCode
        guard (200...299).contains(statusCode) else {
            throw NetworkingError.httpError(statusCode: statusCode)
        }
        return try decoder.decode(ResponseType.self, from: data)
    }
}
