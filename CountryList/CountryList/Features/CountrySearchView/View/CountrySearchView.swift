//
//  CountrySearchView.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//

import SwiftUI

// Country list with search View
struct CountrySearchView: View {
    
    // MARK: - CoreData Properties
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name, order: .forward)]
    )
    private var cdCountries: FetchedResults<CDCountry>
    
    // MARK: - Properties
    @ObservedObject var viewModel: CountryViewModel
    @Environment(\.dismiss) private var dismiss
    
    let maxCountries = 5
    
    struct ConstantsValue {
        static let spacing: CGFloat = 16
        static let zeroSpacing: CGFloat = 0
        static let iconWidth: CGFloat = 40
        static let flagWidth: CGFloat = 64
        static let flagHeight: CGFloat = 32
        static let cornerRadius: CGFloat = 4
        static let inLineSpacing: CGFloat = 8
        static let headerFontSize: CGFloat = 22
        static let headerheight: CGFloat = 44
        static let backBtnHeight: CGFloat = 20
    }
    
    // MARK: - Body
    var body: some View {
        mainView
            .navigationBarBackButtonHidden()
    }
    
}

// MARK: - Views -
extension CountrySearchView {
    
    private var mainView: some View {
        VStack(spacing: ConstantsValue.zeroSpacing) {
            // MARK: Header
            headerView
            // MARK: Search Bar
            SearchBarView(searchText: $viewModel.searchText, placeholder: String.CountrySearchView.searchForACountry)
                .padding(.all)
            Divider()
                .overlay(Color.colorE5E3E1)
            countryList
                .listStyle(.inset)
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
                        .frame(width: ConstantsValue.backBtnHeight, height: ConstantsValue.backBtnHeight)
                        .foregroundColor(.black)
                }
                .frame(width: ConstantsValue.iconWidth, height: ConstantsValue.iconWidth)
                Spacer()
            }
            Text(String.CountrySearchView.navigationTitle)
                .font(.system(size: ConstantsValue.headerFontSize, weight: .medium))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: ConstantsValue.headerheight)
        .padding(.bottom, ConstantsValue.inLineSpacing)
        .background(.ultraThinMaterial)
        .shadow(color: Color.black.opacity(0.05), radius: 3, y: 1)
    }
    
    // MARK: Country List
    private var countryList: some View {
        List(viewModel.filteredCountries.indices, id: \.self) { index in
            let country = viewModel.filteredCountries[index]
            HStack(alignment: .center, spacing: ConstantsValue.spacing) {
                CountryFlagView(country: country)
                    .frame(width: ConstantsValue.flagWidth, height: ConstantsValue.flagHeight)
                    .clipShape(RoundedRectangle(cornerRadius: ConstantsValue.cornerRadius))
                    .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 2)
                CountryInfoView(country: country)
                Spacer(minLength: ConstantsValue.zeroSpacing)
                countryActionButton(for: country)
            }
            .listRowBackground(Color.clear)
        }
    }
    
    // Shows delete button if country is already selected,
    // otherwise shows plus button (disabled if limit reached)
    @ViewBuilder
    private func countryActionButton(for country: Country) -> some View {
        let isSelected = viewModel.selectedCountries.contains(country)
        let isDisabled = viewModel.selectedCountries.count >= maxCountries
        Button {
            if isSelected {
                viewModel.removeCountry(from: country,
                                        cdCountries.map({ $0 }))
            } else {
                viewModel.addCountry(from: country,
                                     cdCountries.map({ $0 }))
            }
        } label: {
            Image(systemName: isSelected ? "trash" : "plus")
                .foregroundColor(.black)
                .frame(width: ConstantsValue.iconWidth, height: ConstantsValue.iconWidth)
                .clipShape(Circle())
        }
        .disabled(!isSelected && isDisabled)
        .buttonStyle(.plain)
    }
    
}
