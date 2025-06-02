//
//  MockCache.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 6/2/25.
//

import UIKit
@testable import Fetch_Recipes

final class MockImageCache: ImageCacheable {
    static var errorToThrow: Error? = nil
    static var didSaveImage: Bool? = nil
    static var didFetchCachedImage: Bool? = nil
    static var mockImage: UIImage? = nil
    
    init() throws {
    }
    
    func save(image: UIImage, config: ImageCacheConfig) async throws {
        Self.didSaveImage = true
        if let error = Self.errorToThrow {
            throw error
        }
    }
    
    func fetchImage(for key: String) async throws -> UIImage? {
        Self.didFetchCachedImage = true
        if let error = Self.errorToThrow {
            throw error
        }
        return Self.mockImage
    }
    
    func flush() async throws {
    }
    
    static func resetMockData() {
        errorToThrow = nil
        didSaveImage = nil
        didFetchCachedImage = nil
        mockImage = nil
    }
}
