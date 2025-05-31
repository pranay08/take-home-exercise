//
//  MockRequestCache.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation
@testable import Fetch_Recipes

class MockRequestCache: RequestCacheable {
    var storedCacheResponse: CachedURLResponse?
    var mockCachedResponse: CachedURLResponse?
    var didRequestCachedResponse: Bool = false
    
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        storedCacheResponse = cachedResponse
    }
    
    func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        didRequestCachedResponse = true
        return mockCachedResponse
    }
}
