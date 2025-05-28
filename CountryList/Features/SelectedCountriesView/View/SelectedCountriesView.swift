//
//  SelectedCountriesView.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//


import SwiftUI

// Selected countries view (if location permission allowed then your country by default selected)
struct SelectedCountriesView: View {
    
    // MARK: - CoreData Properties
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name, order: .forward)]
    )
    private var cdCountries: FetchedResults<CDCountry>
    
    // MARK: - Properties
    @ObservedObject private var viewModel = CountryViewModel()
    @State private var path = NavigationPath()
    
    struct ConstantsValue {
        static let spacing: CGFloat = 16
        static let zeroSpacing: CGFloat = 0
        static let flagWidth: CGFloat = 64
        static let flagHeight: CGFloat = 32
        static let cornerRadius: CGFloat = 12
        static let flagCornerRadius: CGFloat = 4
        static let inLineSpacing: CGFloat = 8
        static let headerFontSize: CGFloat = 16
        static let buttonFontSize: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let buttonTryAgainFontSize: CGFloat = 14
        static let buttonTryAgainHeight: CGFloat = 30
        static let bottomSpacing: CGFloat = 30
        static let viewSpacing: CGFloat = 12
        static let tryAgainCornerRadius: CGFloat = 15
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $path) {
            mainView
                .ignoresSafeArea(edges: .bottom)
                .navigationDestination(for: Country.self) { DetailView(country: $0) }
                .navigationDestination(for: String.self) { route in
                    if route == "search" {
                        CountrySearchView(viewModel: viewModel)
                    }
                }
                .overlay {
                    if viewModel.locationManager.isLocationLoading {
                        Color.black.opacity(0.25).ignoresSafeArea()
                        ProgressView(String.SelectedCountries.progressTitle)
                    }
                }
                .onAppear {
                    Task {
                        await viewModel.fetchCountries(with: cdCountries.map({ $0 }))
                        await viewModel.setupDefaultCountry(with: cdCountries.map({ $0 }))
                    }
                }
        }
    }
        
}

// MARK: - Views -
extension SelectedCountriesView {
    
    // MARK: - Main View
    private var mainView: some View {
        VStack(alignment: .leading, spacing: ConstantsValue.zeroSpacing) {
            // MARK: Header
            headerView
            if viewModel.locationManager.isLocationLoading {
                Spacer()
            } else if viewModel.allCountries.isEmpty && Reachability.shared.connection == .none {
                // MARK: Empty view
                Spacer()
                HStack {
                    Spacer()
                    Text(String.SelectedCountries.noInternetConnection)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding()
                        .padding(.bottom, ConstantsValue.inLineSpacing)
                    Spacer()
                }
                Button {
                    guard Reachability.shared.connection != .none else { return }
                    Task {
                        await viewModel.fetchCountries(with: cdCountries.map({ $0 }))
                        await viewModel.setupDefaultCountry(with: cdCountries.map({ $0 }))
                    }
                } label: {
                    HStack {
                        Text(String.SelectedCountries.tryAgain)
                            .font(.system(size: ConstantsValue.buttonTryAgainFontSize, weight: .medium))
                            .frame(height: ConstantsValue.buttonTryAgainHeight)
                            .padding(ConstantsValue.inLineSpacing)
                    }
                    .foregroundColor(.black.opacity(0.8))
                    .background(
                        RoundedRectangle(cornerRadius: ConstantsValue.tryAgainCornerRadius)
                            .stroke(Color.black.opacity(0.8), lineWidth: 1)
                            .frame(height: ConstantsValue.buttonTryAgainHeight)
                    )
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.plain)
                Spacer()
            }  else if viewModel.selectedCountries.isEmpty {
                // MARK: Empty view
                Spacer()
                HStack {
                    Spacer()
                    Text(String.SelectedCountries.nocountriesAdded)
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                }
                Spacer()
            } else {
                // MARK: Selected countries view
                selectedCountriesView
                    .id(viewModel.reloadTrigger)
            }
            searchButtonView
                .padding(.horizontal, ConstantsValue.spacing)
                .padding(.vertical, ConstantsValue.inLineSpacing)
            Spacer()
                .frame(height: ConstantsValue.bottomSpacing)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(alignment: .leading, spacing: ConstantsValue.inLineSpacing) {
            Text(String.SelectedCountries.navigationTitle)
                .font(.largeTitle.bold())
            if !viewModel.selectedCountries.isEmpty {
                Text(String.SelectedCountries.headerTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: ConstantsValue.headerFontSize, weight: .medium))
                    .foregroundColor(Color.color63605D)
            }
        }
        .padding(.all, ConstantsValue.spacing)
    }
    
    
    // MARK: - Selected Countries List View
    private var selectedCountriesView: some View {
        ScrollView {
            LazyVStack(spacing: ConstantsValue.zeroSpacing) {
                ForEach(viewModel.selectedCountries) { country in
                    NavigationLink(value: country) {
                        HStack(spacing: ConstantsValue.spacing) {
                            CountryFlagView(country: country)
                                .frame(width: ConstantsValue.flagWidth, height: ConstantsValue.flagHeight)
                                .clipShape(RoundedRectangle(cornerRadius: ConstantsValue.flagCornerRadius))
                                .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 2)
                            VStack(alignment: .leading, spacing: ConstantsValue.zeroSpacing) {
                                Text(country.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                if let capital = country.capital {
                                    Text("\(String.DetailView.capitalName) \(capital)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Button(action: {
                                viewModel.removeCountry(from: country,
                                                        cdCountries.map({ $0 }))
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.vertical, ConstantsValue.viewSpacing)
                        .padding(.horizontal, ConstantsValue.spacing)
                    }
                }
            }
        }
    }
    
    // MARK: - Search Button view
    private var searchButtonView: some View {
        Button {
            path.append("search")
        } label: {
            HStack {
                Text(String.SelectedCountries.searchBtnTitle)
                    .font(.system(size: ConstantsValue.buttonFontSize, weight: .medium))
            }
            .frame(maxWidth: .infinity, maxHeight: ConstantsValue.buttonHeight)
            .foregroundColor(.white)
            .background(Color.black.cornerRadius(ConstantsValue.cornerRadius))
        }
        .buttonStyle(.plain)
        .disabled(viewModel.allCountries.isEmpty)
    }

}
