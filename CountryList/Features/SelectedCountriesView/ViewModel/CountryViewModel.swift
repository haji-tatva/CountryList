//
//  CountryViewModel.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//

import Combine
import Foundation
import CoreData
import SwiftUICore
import SwiftUI

// MARK: - CountryViewModel
class CountryViewModel: ObservableObject {

    // MARK: Published
    @Published var allCountries: [Country] = []
    @Published var selectedCountries: [Country] = []
    @Published var searchText = ""
    @Published var reloadTrigger = false
    @Published var locationManager: any LocationManagerImp
    @AppStorage(AppKeys.hasLaunchedBefore) var hasLaunchedBefore = false
    @AppStorage(AppKeys.hasLocationChecked) var hasLocationChecked = false
    let service: CountryServiceImp
    let context: NSManagedObjectContext
    
    // MARK: Private
    private let maxCountries = 5

    // MARK: Init method
    init(
        service: CountryServiceImp = CountryService(),
        locationManager: any LocationManagerImp = LocationManager(),
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.service = service
        self.locationManager = locationManager
        self.context = context
    }

    // MARK: Fetch countries API
    @MainActor
    func fetchCountries(with allLocalCountries: [CDCountry]? = []) async {
        if !hasLocationChecked {
            locationManager.requestPermissionAndLocation()
            hasLocationChecked = true
        }
        selectedCountries = allLocalCountries?.filter { $0.isSaved }.map(Country.init) ?? []
        do {
            let countries = try await service.fetchAllCountries()
            mergeCountriesIntoCoreData(with: countries, allLocalCountries ?? [])
            allCountries = countries
        } catch {
            allCountries = allLocalCountries?.map(Country.init) ?? []
        }
    }

    // Add/Remove user‑saved countries
    func addCountry(from country: Country,
                    _ cdCountries: [CDCountry]) {
        guard selectedCountries.count < maxCountries,
              !selectedCountries.contains(country) else { return }
        selectedCountries.append(country)
        updateSavedFlagsInCoreData(allCountries: cdCountries)
    }

    func removeCountry(from country: Country,
                       _ cdCountries: [CDCountry]) {
        selectedCountries.removeAll { $0 == country }
        updateSavedFlagsInCoreData(allCountries: cdCountries)
    }

    // Core Data helpers
    private func mergeCountriesIntoCoreData(with countries: [Country],
                                            _ allCountries: [CDCountry]) {
        for country in countries {
            if let cd = allCountries.first(where: { $0.id == country.id }) {
                cd.name = country.name
                cd.capital = country.capital
                cd.flag = country.flag
                cd.bestFlagURL = country.bestFlagURL
                merge(country.flags, into: cd)
                merge(country.currencies, into: cd)
            } else {
                let cd = CDCountry(context: context)
                cd.id = country.id
                cd.name = country.name
                cd.capital = country.capital
                cd.flag = country.flag
                cd.bestFlagURL = country.bestFlagURL
                cd.isSaved = false
                merge(country.flags, into: cd)
                merge(country.currencies, into: cd)
            }
        }
        saveContext()
    }

    private func updateSavedFlagsInCoreData(allCountries: [CDCountry]) {
        // Clear all flags then set for current displayed list
        allCountries.forEach { $0.isSaved = false }
        selectedCountries.forEach { findCDCountry(by: $0.id, in: allCountries)?.isSaved = true }
        saveContext()
    }
    
    private func findCDCountry(by id: String, in countries: [CDCountry]) -> CDCountry? {
        return countries.first(where: { $0.id == id })
    }

    // Helpers for nested data
    private func merge(_ flags: Flags?,
                       into country: CDCountry) {
        guard let flags = flags else { return }
        let cdFlags = country.flags ?? CDFlags(context: context)
        cdFlags.png = flags.png
        cdFlags.svg = flags.svg
        country.flags = cdFlags
    }

    // Merge the data after api call
    private func merge(_ currencies: [Currency]?,
                       into country: CDCountry) {
        if let set = country.currencies as? Set<CDCurrency> {
            set.forEach(context.delete)
        }
        currencies?.forEach { cur in
            let cd = CDCurrency(context: context)
            cd.code = cur.code
            cd.currencyName = cur.name
            country.addToCurrencies(cd)
        }
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("CoreData save error:", error)
        }
    }

    // Filtering
    var filteredCountries: [Country] {
        guard !searchText.isEmpty else { return allCountries }
        let needle = searchText.lowercased()
        return allCountries.filter { $0.name.lowercased().contains(needle) }
    }
    
}

extension CountryViewModel {
    
    // Helper async function that waits until location loading is complete
    private func waitForLocationLoading() async {
        while locationManager.isLocationLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        }
    }
    
}

extension CountryViewModel {
    
    // MARK: Setup default country
    func setupDefaultCountry(with cdCountries: [CDCountry]) async {
        // Wait until locationManager finishes loading location info
        if !hasLaunchedBefore {
            await waitForLocationLoading()
            if let detectedCountryName = locationManager.country, !detectedCountryName.isEmpty {
                if selectedCountries.isEmpty,
                   let country = allCountries.first(where: { $0.name == detectedCountryName }) {
                    selectedCountries.append(country)
                    updateSavedFlagsInCoreData(allCountries: cdCountries)
                }
            } else if selectedCountries.isEmpty,
                      let first = allCountries.first {
                addCountry(from: first,
                                     cdCountries.map({ $0 }))
                reloadTrigger.toggle()
            }
            hasLaunchedBefore = true
        } else {
            locationManager.isLocationLoading = false
        }
    }
    
}
