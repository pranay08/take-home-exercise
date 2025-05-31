//
//  EmptyRecipesRequest.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

struct EmptyRecipesRequest: HTTPRequestable {
    var path: String { "/recipes-empty.json" }
    var method: HTTPMethod { .get }
}
