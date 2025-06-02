//
//  RecipeCardView.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import SwiftUI

struct RecipeCardView: View {
    @Environment(\.openURL) private var openURL
    private let viewModel: ViewModel
    
    init(recipe: Recipe) {
        self.viewModel = .init(recipe: recipe)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.headline)
                Text(viewModel.cuisine)
                    .font(.caption)
                HStack(alignment: .bottom) {
                    if let url = viewModel.shareLink {
                        ShareLink(item: url) {
                            Image(systemName: viewModel.shareIconSystemImageName)
                                .font(.subheadline)
                        }
                        .buttonStyle(.borderless)
                    }
                    if let url = viewModel.youtubeLink {
                        Button {
                            openURL(url)
                        } label: {
                            Image(systemName: viewModel.videoIconSystemImageName)
                                .font(.subheadline)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .padding(.top, 8)
            }
            .padding(8)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            AsyncImageView(
                url: viewModel.photoURL,
                cacheKey: viewModel.imageCacheKey
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholderView: {
                Image(systemName: viewModel.placeholderSystemImageName)
            } errorView: {
                Image(systemName: viewModel.errorSystemImageName)
            }
            .frame(height: 160)
            .frame(minWidth: 0, maxWidth: .infinity)
        }
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray)
        )
    }
}

#Preview("Success") {
    RecipeCardView(recipe: .init(
        id: .init(),
        cuisine: "Malaysian",
        name: "Apple and blackberry crumble",
        photoURLSmall: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!,
        photoURLLarge: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!,
        sourceURL: .init(string: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble"),
        youtubeURL: .init(string: "https://www.youtube.com/watch?v=4vhcOwVBDO4")
    ))
}

#Preview("Error Image") {
    RecipeCardView(recipe: .init(
        id: .init(),
        cuisine: "Malaysian",
        name: "Apple and blackberry crumble",
        photoURLSmall: .init(string: "brokenurl")!,
        photoURLLarge: .init(string: "brokenurl")!,
        sourceURL: .init(string: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble"),
        youtubeURL: .init(string: "https://www.youtube.com/watch?v=4vhcOwVBDO4")
    ))
}
