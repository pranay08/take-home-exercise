//
//  RecipesView.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import SwiftUI

struct RecipesView: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        contentView
            .toolbar {
                Button {
                    Task {
                        await viewModel.loadRecipes()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .navigationTitle("Recipes")
            .refreshable {
                Task {
                    await viewModel.loadRecipes()
                }
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading recipes...")
                .task {
                    await viewModel.loadRecipes()
                }
        case .loaded:
            List(viewModel.recipes) { recipe in
                RecipeCardView(recipe: recipe)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                    .listRowBackground(Color.clear)
            }
            .refreshable {
                Task {
                    await viewModel.loadRecipes()
                }
            }
        case .error:
            ContentFillingScrollView {
                VStack(spacing: 16) {
                    Image(.deadFood)
                    Text("Failed to load recipes")
                }
            }
        case .empty:
            ContentFillingScrollView {
                VStack(spacing: 16) {
                    Image(.emptyBasket)
                    Text("No recipes found")
                }
            }
        }
    }
}

#Preview("Success View") {
    RecipesView(
        viewModel: .init(
            requestType: .success
        )
    )
}

#Preview("Empty View") {
    RecipesView(
        viewModel: .init(
            requestType: .empty
        )
    )
}

#Preview("Error View") {
    RecipesView(
        viewModel: .init(
            requestType: .malformed
        )
    )
}
