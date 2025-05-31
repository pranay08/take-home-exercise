//
//  HomeView.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Select an option") {
                    NavigationLink("Recipes List") {
                        RecipesView(viewModel: .init(requestType: .success))
                    }
                    NavigationLink("Error View") {
                        RecipesView(viewModel: .init(requestType: .malformed))
                    }
                    NavigationLink("Empty View") {
                        RecipesView(viewModel: .init(requestType: .empty))
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}
