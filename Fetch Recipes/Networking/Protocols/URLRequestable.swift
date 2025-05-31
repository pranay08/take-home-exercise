//
//  URLRequestable.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

protocol URLRequestable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLRequestable {}
