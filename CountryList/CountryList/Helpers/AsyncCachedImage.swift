//
//  AsyncCachedImage.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//



import SwiftUI

// MARK: - AsyncCachedImage View
struct AsyncCachedImage: View {
    
    // MARK: - Properties
    let url: URL?
    @State private var imageLoadingTask: Task<Void, Error>?
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    // MARK: - View Body
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if isLoading {
                // Show Progress While Loading
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 2))
            }
        }
        .onAppear {
            loadImage()
        }
        .onDisappear {
            imageLoadingTask?.cancel()
        }
    }
    
    // Load Image with Caching
    private func loadImage() {
        guard let url = url, image == nil else { return }
        defer { isLoading = false }
        imageLoadingTask = Task.detached {
            await MainActor.run { isLoading = true }
            if let image = try? await ImageCacheManager.shared.image(for: url) {
                await MainActor.run {
                    self.image = image
                }
            }
        }
    }
}
