//
//  RecipeViewModelTests.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Testing
import Combine
@testable import Fetch_Recipes

struct RecipeViewModelTests {
    @Test("Test load recipes success")
    func testLoadRecipesSuccess() async throws {
        let mockCommunicator = MockHTTPCommunicator()
        mockCommunicator.mockJSONFileName = "recipes"
        let expectedRequest = RecipesRequest()
        let sut = RecipesView.ViewModel(requestType: .success, httpCommunicator: mockCommunicator)
        var cancellables: Set<AnyCancellable> = .init()
        var viewStates: [RecipesView.ViewState] = .init()
        sut.$state.sink {
            viewStates.append($0)
        }.store(in: &cancellables)
        await sut.loadRecipes()
        assert(sut.recipes.count == 63)
        assert(viewStates == [.loading, .loading, .loaded])
        assert(mockCommunicator.sentRequest!.path == expectedRequest.path)
        assert(mockCommunicator.sentRequest!.method == expectedRequest.method)
    }
    
    @Test("Test load recipes error")
    func testLoadRecipesError() async throws {
        let mockCommunicator = MockHTTPCommunicator()
        mockCommunicator.mockJSONFileName = "malformed"
        let expectedRequest = MalformedRequest()
        let sut = RecipesView.ViewModel(requestType: .malformed, httpCommunicator: mockCommunicator)
        var cancellables: Set<AnyCancellable> = .init()
        var viewStates: [RecipesView.ViewState] = .init()
        sut.$state.sink {
            viewStates.append($0)
        }.store(in: &cancellables)
        await sut.loadRecipes()
        assert(sut.recipes.isEmpty == true)
        assert(viewStates == [.loading, .loading, .error])
        assert(mockCommunicator.sentRequest!.path == expectedRequest.path)
        assert(mockCommunicator.sentRequest!.method == expectedRequest.method)
    }
    
    @Test("Test load recipes empty")
    func testLoadRecipesEmpty() async throws {
        let mockCommunicator = MockHTTPCommunicator()
        mockCommunicator.mockJSONFileName = "empty"
        let expectedRequest = EmptyRecipesRequest()
        let sut = RecipesView.ViewModel(requestType: .empty, httpCommunicator: mockCommunicator)
        var cancellables: Set<AnyCancellable> = .init()
        var viewStates: [RecipesView.ViewState] = .init()
        sut.$state.sink {
            viewStates.append($0)
        }.store(in: &cancellables)
        await sut.loadRecipes()
        assert(sut.recipes.isEmpty == true)
        assert(viewStates == [.loading, .loading, .empty])
        assert(mockCommunicator.sentRequest!.path == expectedRequest.path)
        assert(mockCommunicator.sentRequest!.method == expectedRequest.method)
    }
    
    @Test("Test presentation variables")
    func testPresentationVariables() throws {
        let mockCommunicator = MockHTTPCommunicator()
        let sut = RecipesView.ViewModel(requestType: .success, httpCommunicator: mockCommunicator)
        assert(sut.refreshIconSystemName == "arrow.clockwise")
        assert(sut.navigationTitle == "Recipes")
        assert(sut.loadingMessage == "Loading recipes...")
        assert(sut.errorImageResource == .deadFood)
        assert(sut.errorViewMessage == "Failed to load recipes")
        assert(sut.emptyImageResource == .emptyBasket)
        assert(sut.emptyViewMessage == "No recipes found")
    }
}
