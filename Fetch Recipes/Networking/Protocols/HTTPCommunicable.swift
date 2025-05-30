//
//  HTTPCommunicable.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

protocol HTTPCommunicable {
    func send<ResponseType>(
        request: HTTPRequestable
    ) async throws -> ResponseType where ResponseType: Decodable
    
    func send<ResponseType>(
        request: HTTPRequestable,
        decoder: JSONDecoder
    ) async throws -> ResponseType where ResponseType: Decodable
}

extension HTTPCommunicable {
    func send<ResponseType>(
        request: HTTPRequestable
    ) async throws -> ResponseType where ResponseType: Decodable {
        return try await send(request: request, decoder: .init())
    }
}
