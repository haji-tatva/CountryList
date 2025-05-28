//
//  CountryFlagView.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//


import SwiftUI

// Country flag view
struct CountryFlagView: View {
    
    // MARK: - Properties
    let country: Country
    
    // MARK: - Body
    var body: some View {
        if let urlString = country.bestFlagURL,
           let url = URL(string: urlString) {
            CacheAsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                default:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                }
            }
        } else {
            // MARK: Show Progress While Loading
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
    
}
