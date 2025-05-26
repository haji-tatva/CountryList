//
//  ImageCacheError.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//


import UIKit

enum ImageCacheError: Error {
    case imageNotFound
}

final class ImageCacheManager {
    static let shared = ImageCacheManager()

    private let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    func image(for url: URL) async throws -> UIImage {
        let cacheKey = url.absoluteString as NSString
        
        // Return from cache if available
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        // Otherwise download
        do {
            let response = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: response.0)
            else { throw ImageCacheError.imageNotFound }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            throw error
        }
    }
}