//
//  HTTPRequestable.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

protocol HTTPRequestable {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [String: String]? { get }
    var additionaHeaderFields: [String: String]? { get }
}

extension HTTPRequestable {
    var queryParameters: [String: String]? {
        return nil
    }
    
    var additionaHeaderFields: [String: String]? {
        return nil
    }
}
