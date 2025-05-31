//
//  MalformedRequest.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

struct MalformedRequest: HTTPRequestable {
    var path: String { "/recipes-malformed.json" }
    var method: HTTPMethod { .get }
}
