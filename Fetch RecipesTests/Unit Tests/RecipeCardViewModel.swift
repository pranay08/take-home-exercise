//
//  RecipeCardViewModel.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Testing
import Combine
import UIKit
import SwiftUICore
@testable import Fetch_Recipes

struct RecipeCardViewModel {
    @Test("Test view presentation variables")
    func testViewPresentationVariables() async throws {
        let mockRecipe = Recipe(
            id: .init(),
            cuisine: "Mock cuisine",
            name: "Mock dish name",
            photoURLSmall: .init(string: "www.google.com")!,
            photoURLLarge: .init(string: "www.google.com")!,
            sourceURL: .init(string: "www.google.com"),
            youtubeURL: .init(string: "www.google.com")
        )
        let sut = RecipeCardView.ViewModel(recipe: mockRecipe)
        assert(sut.name == mockRecipe.name)
        assert(sut.cuisine == "Cuisine: \(mockRecipe.cuisine)")
        assert(sut.photoURL == mockRecipe.photoURLLarge)
        assert(sut.shareLink == mockRecipe.sourceURL)
        assert(sut.youtubeLink == mockRecipe.youtubeURL)
        assert(sut.placeholderSystemImageName == "photo")
        assert(sut.errorSystemImageName == "photo.badge.exclamationmark")
        assert(sut.shareIconSystemImageName == "square.and.arrow.up")
        assert(sut.videoIconSystemImageName == "video")
    }
}
