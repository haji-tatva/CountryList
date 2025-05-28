//
//  CountryInfoView.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//


import SwiftUI

// Country info view
struct CountryInfoView: View {
    
    // MARK: - Properties
    let country: Country
    
    struct ConstantsValue {
        static let inLineSpacing: CGFloat = 4
        static let nameFontSize: CGFloat = 16
        static let descriptionFontSize: CGFloat = 14
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: ConstantsValue.inLineSpacing) {
            Text(country.name)
                .font(.system(size: ConstantsValue.nameFontSize, weight: .medium))
            VStack(alignment: .leading, spacing: ConstantsValue.inLineSpacing) {
                if let capital = country.capital, !capital.isEmpty {
                    descriptionText(with: "Capital: \(capital)")
                }
                if let currency = country.currencies?.first {
                    descriptionText(with: "Currency: \(currency.code ?? "-")")
                }
            }
        }
    }
    
}

// MARK: - Views -
extension CountryInfoView {
    
    private func descriptionText(with title: String) -> some View {
        Text(title)
            .frame(alignment: .leading)
            .font(.system(size: ConstantsValue.descriptionFontSize, weight: .regular))
            .foregroundColor(.secondary)
    }
    
}
