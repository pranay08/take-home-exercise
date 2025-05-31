//
//  AsyncImageViewModelTests.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Testing
import Combine
import UIKit
import SwiftUICore
@testable import Fetch_Recipes

struct AsyncImageViewModelTests {
    @Test("Test load image with no URL")
    func testLoadImageWithNoURL() async throws {
        let mockRequester = MockURLRequester()
        let mockCache = MockRequestCache()
        let SutType = AsyncImageView<Image, EmptyView, EmptyView>.self
        let sut = SutType.ViewModel(url: nil, requester: mockRequester, cache: mockCache)
        var cancellables: Set<AnyCancellable> = .init()
        var viewStates = [SutType.ViewState.error]
        viewStates = []
        sut.$state.sink {
            viewStates.append($0)
        }.store(in: &cancellables)
        await sut.loadImage()
        assert(viewStates == [.none, .error])
    }
    
    @Test("Test load image from cache with success")
    func testLoadImageURLFromCacheWithSuccess() async throws {
        let mockURL = URL(string: "https://www.google.com")
        let mockImageData = UIImage(resource: .deadFood).pngData()!
        let mockRequester = MockURLRequester()
        let mockCache = MockRequestCache()
        mockCache.mockCachedResponse = .init(response: .init(), data: mockImageData)
        let SutType = AsyncImageView<Image, EmptyView, EmptyView>.self
        let sut = SutType.ViewModel(url: mockURL, requester: mockRequester, cache: mockCache)
        var cancellables: Set<AnyCancellable> = .init()
        var viewStates = [SutType.ViewState.error]
        viewStates = []
        sut.$state.sink {
            viewStates.append($0)
        }.store(in: &cancellables)
        await sut.loadImage()
        assert(viewStates.count == 3)
        assert(viewStates[0] == .none)
        assert(viewStates[1] == .loading)
        assert({
            guard case .loaded = viewStates[2] else {
                return false
            }
            return true
        }() == true)
        assert(mockRequester.didRequestData == false)
        assert(mockCache.didRequestCachedResponse == true)
        assert(mockCache.storedCacheResponse == nil)
    }
    
    @Test("Test load image from URL requester and store in cache")
    func testLoadImageURLFromURLRequesterAndStoreInCache() async throws {
        let mockURL = URL(string: "https://www.google.com")
        let mockImageData = UIImage(resource: .deadFood).pngData()!
        let mockRequester = MockURLRequester()
        mockRequester.mockData = mockImageData
        mockRequester.mockResponse = .init()
        let mockCache = MockRequestCache()
        mockCache.mockCachedResponse = nil
        let SutType = AsyncImageView<Image, EmptyView, EmptyView>.self
        let sut = SutType.ViewModel(url: mockURL, requester: mockRequester, cache: mockCache)
        var cancellables: Set<AnyCancellable> = .init()
        var viewStates = [SutType.ViewState.error]
        viewStates = []
        sut.$state.sink {
            viewStates.append($0)
        }.store(in: &cancellables)
        await sut.loadImage()
        assert(viewStates.count == 3)
        assert(viewStates[0] == .none)
        assert(viewStates[1] == .loading)
        assert({
            guard case .loaded = viewStates[2] else {
                return false
            }
            return true
        }() == true)
        assert(mockRequester.didRequestData == true)
        assert(mockCache.didRequestCachedResponse == true)
        assert(mockCache.storedCacheResponse?.data == mockImageData)
    }
    
    @Test("Test load image from URL requester with error")
    func testLoadImageURLFromURLRequesterWithError() async throws {
        let mockURL = URL(string: "https://www.google.com")
        let mockRequester = MockURLRequester()
        mockRequester.mockError = MockError.generic
        let mockCache = MockRequestCache()
        mockCache.mockCachedResponse = nil
        let SutType = AsyncImageView<Image, EmptyView, EmptyView>.self
        let sut = SutType.ViewModel(url: mockURL, requester: mockRequester, cache: mockCache)
        var cancellables: Set<AnyCancellable> = .init()
        var viewStates = [SutType.ViewState.error]
        viewStates = []
        sut.$state.sink {
            viewStates.append($0)
        }.store(in: &cancellables)
        await sut.loadImage()
        assert(viewStates == [.none, .loading, .error])
        assert(mockRequester.didRequestData == true)
        assert(mockCache.didRequestCachedResponse == true)
        assert(mockCache.storedCacheResponse?.data == nil)
    }
}
