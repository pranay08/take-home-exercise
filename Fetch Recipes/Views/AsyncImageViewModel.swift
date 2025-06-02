//
//  AsyncImageViewModel.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import SwiftUI

extension AsyncImageView {
    final class ViewModel: ObservableObject {
        @Published private(set) var state: ViewState = .none
        
        private let url: URL?
        private let requester: URLRequestable
        private let cache: ImageCacheable?
        private let cacheKey: String?
        private let cacheTimeToLive: TimeInterval
        
        init(
            url: URL?,
            requester: URLRequestable = URLSession.shared,
            cacheType: ImageCacheable.Type = ImageCache.self,
            cacheKey: String? = nil,
            cacheTimeToLive: TimeInterval = 60 * 60 * 24
        ) {
            self.url = url
            self.requester = requester
            do {
                self.cache = try cacheType.init()
            } catch {
                assertionFailure("Unable to load image cache")
                self.cache = nil
            }
            self.cacheKey = cacheKey
            self.cacheTimeToLive = cacheTimeToLive
        }
        
        @MainActor
        func loadImage() async {
            guard state != .loading else { return }
            
            guard let url else {
                state = .error
                return
            }
            
            state = .loading
            
            if let cacheKey,
               let image = try? await cache?.fetchImage(for: cacheKey) {
                state = .loaded(.init(uiImage: image))
            } else {
                let request = URLRequest(url: url)
                await downloadImage(from: request)
            }
        }
        
        @MainActor
        private func downloadImage(from request: URLRequest) async {
            do {
                let (data, _) = try await requester.data(for: request)
                guard let image = UIImage(data: data) else {
                    state = .error
                    return
                }
                state = .loaded(.init(uiImage: image))
                if let cacheKey {
                    let config = ImageCacheConfig(key: cacheKey, timeToLive: cacheTimeToLive)
                    do {
                        try await cache?.save(image: image, config: config)
                    } catch {
                        print("cache save error")
                    }
                }
            } catch {
                state = .error
            }
        }
    }
    
    enum ViewState: Equatable {
        case none
        case loading
        case loaded(Image)
        case error
    }
}
