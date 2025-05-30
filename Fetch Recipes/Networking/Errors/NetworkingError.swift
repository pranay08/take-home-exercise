//
//  NetworkingError.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

enum NetworkingError: Error {
    case badRequest
    case badResponse
    case httpError(statusCode: Int)
}
