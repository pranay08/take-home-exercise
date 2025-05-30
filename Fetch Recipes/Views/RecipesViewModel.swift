//
//  RecipesViewModel.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

extension RecipesView {
    final class ViewModel: ObservableObject {
        @Published private(set) var state: ViewState = .loading
        @Published private(set) var recipes: [Recipe] = []
        
        private let requestType: RequestType
        private let httpCommunicator: any HTTPCommunicable
        
        init(requestType: RequestType, httpCommunicator: any HTTPCommunicable = HTTPCommunicator()) {
            self.requestType = requestType
            self.httpCommunicator = httpCommunicator
        }
        
        @MainActor
        func loadRecipes() async {
            do {
                state = .loading
                let response: Recipes = try await httpCommunicator.send(request: requestType.httpRequest)
                recipes = response.recipes
                if recipes.isEmpty {
                    state = .empty
                } else {
                    state = .loaded
                }
            } catch {
                state = .error
            }
        }
    }
    
    enum ViewState {
        case loading
        case loaded
        case error
        case empty
    }
    
    enum RequestType {
        case success
        case malformed
        case empty
        
        var httpRequest: any HTTPRequestable {
            switch self {
            case .success:
                RecipesRequest()
            case .malformed:
                MalformedRequest()
            case .empty:
                EmptyRecipesRequest()
            }
        }
    }
}

extension Recipe: Identifiable {}
