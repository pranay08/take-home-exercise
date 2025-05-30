//
//  Recipe.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

struct Recipe: Decodable {
    let id: UUID
    let cuisine: String
    let name: String
    let photoURLSmall: URL
    let photoURLLarge: URL
    let sourceURL: URL?
    let youtubeURL: URL?
    
    private enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine = "cuisine"
        case name = "name"
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
