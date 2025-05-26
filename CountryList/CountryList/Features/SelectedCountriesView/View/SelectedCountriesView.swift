//
//  SelectedCountriesView.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//


import SwiftUI

// Selected countries view (if location permission allowed then your country by default selected)
struct SelectedCountriesView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = CountryViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var path = NavigationPath()
    @State private var isFirstLaunch = AppSettings.isFirstLaunch
    @State private var reloadTrigger = false
    
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
        static let bottomSpacing: CGFloat = 30
        static let viewSpacing: CGFloat = 12
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
                    if locationManager.isLocationLoading {
                        Color.black.opacity(0.25)
                            .ignoresSafeArea()
                        ProgressView("Fetching location…")
                    }
                }
                .task {
                    if AppSettings.shouldCheckLocation {
                        locationManager.requestPermissionAndLocation()
                    }
                    viewModel.fetchCountries()
                    await setupDefaultCountry()
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
            if locationManager.isLocationLoading {
                Spacer()
            } else if viewModel.displayedCountries.isEmpty {
                // MARK: Empty view
                Spacer()
                HStack {
                    Spacer()
                    Text("No countries added yet.")
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                }
                Spacer()
            } else {
                // MARK: Selected countries view
                selectedCountriesView
                    .id(reloadTrigger)
            }
            searchButtonView
                .frame(maxWidth: .infinity)
                .background(Color.black.cornerRadius(ConstantsValue.cornerRadius))
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
            if !viewModel.displayedCountries.isEmpty {
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
                ForEach(viewModel.displayedCountries) { country in
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
                                if let capital = country.capital {
                                    Text("Capital: \(capital)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Button(action: {
                                viewModel.removeCountry(country)
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
                Text("Search Country")
                    .font(.system(size: ConstantsValue.buttonFontSize, weight: .medium))
            }
            .frame(height: ConstantsValue.buttonHeight)
            .foregroundColor(.white)
        }
    }

}

// MARK: - Helper methods -
extension SelectedCountriesView {
    
    // Helper async function that waits until Api loading is complete
    private func waitForApiLoading() async {
        while viewModel.isApiLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 s
        }
    }
    
    // Helper async function that waits until location loading is complete
    private func waitForLocationLoading() async {
        while locationManager.isLocationLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 s
        }
    }
    
}

// MARK: - Helper methods -
extension SelectedCountriesView {
    
    // MARK: - Setup default country
    private func setupDefaultCountry() async {
        // Wait until locationManager finishes loading location info
        if isFirstLaunch {
            await waitForLocationLoading()
            await waitForApiLoading()
            // Check detected country name from locationManager
            if let detectedCountryName = locationManager.country, !detectedCountryName.isEmpty {
                // Location permission allowed and country detected
                viewModel.setDefaultCountryIfNeeded(detectedCountryName: detectedCountryName)
            } else if viewModel.displayedCountries.isEmpty,
                      let first = viewModel.allCountries.first {
                viewModel.addCountry(first)
                reloadTrigger.toggle()
            }
        } else {
            locationManager.isLocationLoading = false
        }
    }
    
}
