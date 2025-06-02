//
//  AsyncImageView.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import SwiftUI

struct AsyncImageView<ContentImage, Placeholder, Error>: View where ContentImage: View, Placeholder: View, Error: View {
    @ObservedObject private var viewModel: ViewModel
    
    private let imageView: (Image) -> ContentImage
    private let placeholderView: () -> Placeholder?
    private let errorView: () -> Error?
    
    init(
        url: URL?,
        cacheKey: String? = nil,
        @ViewBuilder content: @escaping (Image) -> ContentImage = { $0 },
        @ViewBuilder placeholderView: @escaping () -> Placeholder? = { Rectangle() },
        @ViewBuilder errorView: @escaping () -> Error? = { EmptyView() }
    ) {
        self.imageView = content
        self.placeholderView = placeholderView
        self.errorView = errorView
        self.viewModel = .init(url: url, cacheKey: cacheKey)
    }
    
    var body: some View {
        switch viewModel.state {
        case .none, .loading:
            placeholderView()
                .task {
                    await viewModel.loadImage()
                }
        case .loaded(let image):
            imageView(image)
        case .error:
            errorView()
        }
    }
}

#Preview("Success View") {
    AsyncImageView(
        url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
    ) { image in
        image
            .resizable()
            .scaledToFit()
    }
}

#Preview("Error View") {
    AsyncImageView(
        url: URL(string: "someurl")
    ) { image in
        image
            .resizable()
            .scaledToFit()
    } placeholderView: {
        ProgressView()
    } errorView: {
        Image(systemName: "photo.badge.exclamationmark")
            .font(.title)
            .foregroundStyle(.secondary)
        Text("Error")
    }
}
