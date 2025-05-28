//
//  SearchBarView.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//


import SwiftUI

// Search bar view for search country
struct SearchBarView: View {
    
    // MARK: - Binding Properties
    @Binding var searchText: String
    var placeholder: String = "Search"
    
    struct ConstantsValue {
        static let cornerRadius: CGFloat = 8
        static let inLineSpacing: CGFloat = 8
        static let lineWidth: CGFloat = 1
        static let searchHeight: CGFloat = 40
    }
    
    // MARK: - Body
    var body: some View {
        mainView
            .overlay(
                RoundedRectangle(cornerRadius: ConstantsValue.cornerRadius)
                    .stroke(Color.gray.opacity(0.5), lineWidth: ConstantsValue.lineWidth)
            )
    }
    
}

// MARK: - Views -
extension SearchBarView {
    
    private var mainView: some View {
        HStack {
            // Search Icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            // Search TextField
            TextField(placeholder, text: $searchText)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .tint(.black)
            // Clear Button - shown when searchText is not empty
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(height: ConstantsValue.searchHeight)
        .padding(.horizontal, ConstantsValue.inLineSpacing)
    }
    
}
