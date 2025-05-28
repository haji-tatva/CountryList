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
    
    struct ConstantsValue {
        static let cornerRadius: CGFloat = 4
    }
    
    // MARK: - Body
    var body: some View {
        if let urlString = country.bestFlagURL,
           let url = URL(string: urlString) {
            AsyncCachedImage(url: url)
        } else {
            // MARK: Show Progress While Loading
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
    
}
