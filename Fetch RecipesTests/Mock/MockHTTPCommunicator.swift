//
//  MockHTTPCommunicator.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation
@testable import Fetch_Recipes

final class MockHTTPCommunicator: HTTPCommunicable {
    var mockError: Error?
    var mockJSONFileName: String?
    var sentRequest: (any HTTPRequestable)?
    
    func send<ResponseType>(
        request: any HTTPRequestable,
        decoder: JSONDecoder
    ) async throws -> ResponseType where ResponseType : Decodable {
        sentRequest = request
        if let mockError {
            throw mockError
        }
        guard let mockJSONFileName else {
            throw MockError.generic
        }
        let bundle = Bundle(for: type(of: self))
        guard let fileUrl = bundle.url(forResource: mockJSONFileName, withExtension: "json") else {
            throw MockError.generic
        }
        let data = try Data(contentsOf: fileUrl)
        return try decoder.decode(ResponseType.self, from: data)
    }
}

enum MockError: Error {
    case generic
}
