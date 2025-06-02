//
//  RecipeCardViewModel.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

extension RecipeCardView {
    final class ViewModel {
        var name: String { recipe.name }
        var cuisine: String { "Cuisine: \(recipe.cuisine)"}
        var photoURL: URL? { recipe.photoURLLarge }
        var shareLink: URL? { recipe.sourceURL }
        var youtubeLink: URL? { recipe.youtubeURL }
        var placeholderSystemImageName: String { "photo" }
        var errorSystemImageName: String { "photo.badge.exclamationmark" }
        var shareIconSystemImageName: String { "square.and.arrow.up" }
        var videoIconSystemImageName: String { "video" }
        var imageCacheKey: String { recipe.id.uuidString }
        
        private let recipe: Recipe
        
        init(recipe: Recipe) {
            self.recipe = recipe
        }
    }
}
