//
//  DetailView.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//


import SwiftUI

// Country detail View
struct DetailView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    let country: Country
    
    struct ConstantsValue {
        static let spacing: CGFloat = 16
        static let zeroSpacing: CGFloat = 0
        static let inLineSpacing: CGFloat = 8
        static let headerFontSize: CGFloat = 22
        static let titleFontSize: CGFloat = 12
        static let descriptionFontSize: CGFloat = 16
        static let headerheight: CGFloat = 44
        static let viewSpacing: CGFloat = 12
        static let detailSpacing: CGFloat = 4
    }
    
    // MARK: - Body
    var body: some View {
        mainView
            .navigationBarBackButtonHidden()
    }
    
}

// MARK: - Views -
extension DetailView {
    
    // MARK: - Main View
    private var mainView: some View {
        VStack(spacing: ConstantsValue.zeroSpacing) {
            // MARK: Header
            headerView
            // MARK: - Country flag view
            CountryFlagView(country: country)
                .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 2)
                .frame(maxWidth: .infinity)
            // MARK: - Country Info
            countryInfoView
            Spacer()
        }
    }
    
    // MARK: Header view
    private var headerView: some View {
        ZStack {
            HStack(spacing: ConstantsValue.zeroSpacing) {
                Button(action: dismiss.callAsFunction) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
                .padding(.leading)
                Spacer()
            }
            // Centered title
            Text(String.DetailView.navigationTitle)
                .font(.system(size: ConstantsValue.headerFontSize, weight: .medium))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: ConstantsValue.headerheight)
        .padding(.bottom, ConstantsValue.inLineSpacing)
        .shadow(color: Color.black.opacity(0.05), radius: 3, y: 1)
    }
    
    // Country Info
    private var countryInfoView: some View {
        VStack(alignment: .leading, spacing: ConstantsValue.viewSpacing) {
            countryDetailView(with: String.DetailView.countryName,
                              country.name)
            Divider()
            countryDetailView(with: String.DetailView.capitalName,
                              country.capital ?? "N/A")
            Divider()
            if let currency = country.currencies?.first {
                countryDetailView(with: String.DetailView.currencyName,
                                  "\(currency.name ?? "Unknown") (\(currency.code ?? ""))")
            } else {
                countryDetailView(with: String.DetailView.currencyName,
                                  "N/A")
            }
            Spacer()
        }
        .padding()
    }
    
}

// MARK: - Helper methods -
extension DetailView {
    
    func countryDetailView(with title: String,
                                   _ description: String) -> some View {
        VStack(alignment: .leading, spacing: ConstantsValue.detailSpacing) {
            Text(title)
                .font(.system(size: ConstantsValue.titleFontSize, weight: .medium))
                .foregroundColor(Color.color504B46)
            Text(description)
                .font(.system(size: ConstantsValue.descriptionFontSize, weight: .regular))
                .foregroundColor(Color.color262626)
        }
    }
    
}
