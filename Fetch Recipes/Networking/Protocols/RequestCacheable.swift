//
//  RequestCacheable.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

protocol RequestCacheable {
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest)
    func cachedResponse(for request: URLRequest) -> CachedURLResponse?
}

extension URLCache: RequestCacheable {}
