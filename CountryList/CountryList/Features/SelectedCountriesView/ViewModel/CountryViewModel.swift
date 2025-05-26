//
//  CountryViewModel.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//


import SwiftUI
import Combine

// MARK: - CountryViewModel

class CountryViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var allCountries: [Country] = []
    @Published var displayedCountries: [Country] = []
    @Published var searchText: String = ""
    @Published var noCountriesAvailable: Bool = false
    @Published var isApiLoading: Bool = true
    
    // MARK: - Private Properties
    private let service = CountryService()
    private var cancellables = Set<AnyCancellable>()
    
    private let locationManager = LocationManager()
    private var defaultCountrySet = false
    
    // MARK: - Initialization
    init() {
        fetchCountries()
    }
    
    // MARK: - Fetch Countries
    func fetchCountries() {
        service.fetchAllCountries { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let countries):
                    self.allCountries = countries
                    self.syncSavedWithLatest(all: countries)
                    self.noCountriesAvailable = countries.isEmpty
                    self.isApiLoading = false
                case .failure(let error):
                    self.noCountriesAvailable = self.allCountries.isEmpty
                    self.isApiLoading = false
                }
            }
        }
    }
    
    // MARK: - Sync saved displayed countries with latest API data
    private func syncSavedWithLatest(all: [Country]) {
        let updatedDisplayed = displayedCountries.compactMap { saved in
            all.first(where: { $0.name == saved.name })
        }
        displayedCountries = updatedDisplayed
    }
    
    // MARK: - Manage Selected Countries
    func addCountry(_ country: Country) {
        guard displayedCountries.count < 5, !displayedCountries.contains(country) else { return }
        displayedCountries.append(country)
    }
    
    func removeCountry(_ country: Country) {
        displayedCountries.removeAll { $0 == country }
    }
    
    // MARK: - Filtering
    var filteredCountries: [Country] {
        searchText.isEmpty ? allCountries : allCountries.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    // MARK: - Set Default Country Based on Location
    
    func setDefaultCountryIfNeeded(detectedCountryName: String) {
        guard !defaultCountrySet else { return }
        if let defaultCountry = allCountries.first(where: { $0.name == detectedCountryName }),
           displayedCountries.count < 5,
           !displayedCountries.contains(where: { $0.name == detectedCountryName }) {
            displayedCountries.append(defaultCountry)
            defaultCountrySet = true
        }
    }
}



