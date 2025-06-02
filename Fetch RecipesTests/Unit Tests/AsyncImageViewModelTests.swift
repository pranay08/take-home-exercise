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
        let mockCacheType = MockImageCache.self
        mockCacheType.resetMockData()
        let SutType = AsyncImageView<Image, EmptyView, EmptyView>.self
        let sut = SutType.ViewModel(url: nil, requester: mockRequester, cacheType: mockCacheType)
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
        let mockImage = UIImage(resource: .deadFood)
        let mockRequester = MockURLRequester()
        let mockCacheType = MockImageCache.self
        mockCacheType.resetMockData()
        mockCacheType.mockImage = mockImage
        let SutType = AsyncImageView<Image, EmptyView, EmptyView>.self
        let sut = SutType.ViewModel(url: mockURL, requester: mockRequester, cacheType: mockCacheType, cacheKey: "mock")
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
        assert(mockCacheType.didFetchCachedImage == true)
        assert(mockCacheType.didSaveImage == nil)
    }
    
    @Test("Test load image from URL requester and store in cache")
    func testLoadImageURLFromURLRequesterAndStoreInCache() async throws {
        let mockURL = URL(string: "https://www.google.com")
        let mockImageData = UIImage(resource: .deadFood).pngData()!
        let mockRequester = MockURLRequester()
        mockRequester.mockData = mockImageData
        mockRequester.mockResponse = .init()
        let mockCacheType = MockImageCache.self
        mockCacheType.resetMockData()
        let SutType = AsyncImageView<Image, EmptyView, EmptyView>.self
        let sut = SutType.ViewModel(url: mockURL, requester: mockRequester, cacheType: mockCacheType, cacheKey: "mock")
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
        assert(mockCacheType.didFetchCachedImage == true)
        assert(mockCacheType.didSaveImage == true)
    }
    
    @Test("Test load image from URL requester with error")
    func testLoadImageURLFromURLRequesterWithError() async throws {
        let mockURL = URL(string: "https://www.google.com")
        let mockRequester = MockURLRequester()
        mockRequester.mockError = MockError.generic
        let mockCacheType = MockImageCache.self
        mockCacheType.resetMockData()
        let SutType = AsyncImageView<Image, EmptyView, EmptyView>.self
        let sut = SutType.ViewModel(url: mockURL, requester: mockRequester, cacheType: mockCacheType, cacheKey: "mock")
        var cancellables: Set<AnyCancellable> = .init()
        var viewStates = [SutType.ViewState.error]
        viewStates = []
        sut.$state.sink {
            viewStates.append($0)
        }.store(in: &cancellables)
        await sut.loadImage()
        assert(viewStates == [.none, .loading, .error])
        assert(mockRequester.didRequestData == true)
        assert(mockCacheType.didFetchCachedImage == true)
        assert(mockCacheType.didSaveImage == nil)
    }
}
