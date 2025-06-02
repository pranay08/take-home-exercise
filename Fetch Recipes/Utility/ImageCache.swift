//
//  ImageCache.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 6/2/25.
//

import UIKit

struct ImageCacheConfig {
    let key: String
    var timeToLive: TimeInterval = 24 * 60 * 60 * 30 // 30 days default
}

protocol ImageCacheable {
    init() throws
    func save(image: UIImage, config: ImageCacheConfig) async throws
    func fetchImage(for key: String) async throws -> UIImage?
    func flush() async throws
}

final actor ImageCache {
    private let cacheDirectoryURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    // MARK: - Object Lifecycle
    
    init() throws {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw FileManagerError.cachesDirectoryNotFound
        }
        self.cacheDirectoryURL = cacheDirectory.appending(path: Constants.cacheDirectoryPath)
        if !FileManager.default.fileExists(atPath: cacheDirectoryURL.path()) {
            try FileManager.default.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        self.encoder = .init()
        self.decoder = .init()
    }
    
    // MARK: - Private
    
    private func fileURL(for key: String) throws -> URL {
        guard let path = key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw FileManagerError.invalidKey
        }
        return cacheDirectoryURL.appending(path: path)
    }
}

// MARK: - ImageCacheable

extension ImageCache: ImageCacheable {
    func save(image: UIImage, config: ImageCacheConfig) async throws {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            throw FileManagerError.corruptImageData
        }
        let fileURL = try fileURL(for: config.key)
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            DispatchQueue.global(qos: .utility).async {
                guard let self else {
                    return
                }
                do {
                    try data.write(to: fileURL, options: .atomic)
                    let expiryDate = Date.now.addingTimeInterval(config.timeToLive)
                    let expiryDateData = try self.encoder.encode(expiryDate)
                    try expiryDateData.write(
                        to: fileURL.appendingPathExtension(for: .json),
                        options: .atomic
                    )
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchImage(for key: String) async throws -> UIImage? {
        let fileURL = try fileURL(for: key)
        let expiryDateURL = fileURL.appendingPathExtension(for: .json)
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            DispatchQueue.global(qos: .utility).async {
                guard let self else {
                    return
                }
                do {
                    if FileManager.default.fileExists(atPath: expiryDateURL.path()) {
                        let expiryDateData = try Data(contentsOf: expiryDateURL)
                        let expiryDate = try self.decoder.decode(Date.self, from: expiryDateData)
                        if expiryDate < .now {
                            try FileManager.default.removeItem(at: fileURL)
                            try FileManager.default.removeItem(at: expiryDateURL)
                            continuation.resume(returning: nil)
                        }
                    }
                    
                    guard FileManager.default.fileExists(atPath: fileURL.path()) else {
                        continuation.resume(returning: nil)
                        return
                    }
                    
                    let data = try Data(contentsOf: fileURL)
                    let image = UIImage(data: data)
                    continuation.resume(returning: image)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // This isn't called from anywhere, but if we need to flush cache, we can call this function.
    func flush() async throws {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            DispatchQueue.global(qos: .utility).async {
                guard let self else {
                    return
                }
                do {
                    let contents = try FileManager.default.contentsOfDirectory(atPath: self.cacheDirectoryURL.path)
                    try contents.forEach {
                        let fileURL = self.cacheDirectoryURL.appendingPathComponent($0)
                        try FileManager.default.removeItem(at: fileURL)
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

private extension ImageCache {
    enum Constants {
        static let cacheDirectoryPath: String = "com.fetchRecipes.ImageCache"
    }
}

enum FileManagerError: Error {
    case cachesDirectoryNotFound
    case corruptImageData
    case invalidKey
}
