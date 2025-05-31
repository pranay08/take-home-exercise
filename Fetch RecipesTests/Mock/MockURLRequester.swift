//
//  MockURLRequester.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation
@testable import Fetch_Recipes

class MockURLRequester: URLRequestable {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    var didRequestData: Bool = false
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        didRequestData = true
        guard let mockData,
              let mockResponse else {
            throw mockError ?? MockError.generic
        }
        return (mockData, mockResponse)
    }
}
