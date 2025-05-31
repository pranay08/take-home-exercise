//
//  RecipesRequest.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

struct RecipesRequest: HTTPRequestable {
    var path: String { "/recipes.json" }
    var method: HTTPMethod { .get }
}
