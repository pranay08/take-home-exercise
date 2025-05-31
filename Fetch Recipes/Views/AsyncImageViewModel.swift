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
        private let cache: RequestCacheable
        
        init(
            url: URL?,
            requester: URLRequestable = URLSession.shared,
            cache: RequestCacheable = URLCache.shared
        ) {
            self.url = url
            self.requester = requester
            self.cache = cache
        }
        
        @MainActor
        func loadImage() async {
            guard state != .loading else { return }
            
            guard let url else {
                state = .error
                return
            }
            
            state = .loading
            
            let request = URLRequest(url: url)
            if let response = cache.cachedResponse(for: request),
                  let image = UIImage(data: response.data) {
                state = .loaded(.init(uiImage: image))
            } else {
                await downloadImage(from: request)
            }
        }
        
        @MainActor
        private func downloadImage(from request: URLRequest) async {
            do {
                let (data, response) = try await requester.data(for: request)
                guard let image = UIImage(data: data) else {
                    state = .error
                    return
                }
                let cachedData = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedData, for: request)
                state = .loaded(.init(uiImage: image))
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
