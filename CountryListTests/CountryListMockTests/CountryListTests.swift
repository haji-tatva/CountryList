//
//  CountryListTests.swift
//  CountryListTests
//
//  Created by MACM23 on 26/05/25.
//

import XCTest
import CoreData
@testable import CountryList

final class CountryListTests: XCTestCase {
    
    @MainActor
    private func createViewModel(with countries: [Country]
    ) -> CountryViewModel {
        CountryViewModel(
            service: APIServiceMock(mockCountriesData: countries),
            locationManager: LocationServiceMock(country: "AFG", isLocationLoading: true),
            context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        )
    }
    
    private func createMockCoreData(with allCountires: [Country], context: NSManagedObjectContext) -> [CDCountry] {
        allCountires.map { country in
            let cd = CDCountry(context: context)
            cd.id = country.id
            cd.name = country.name
            cd.capital = country.capital
            cd.flag = country.flag
            return cd
        }
    }
    
    func testFetchAllCountries() {
        Task { @MainActor in
            let viewModel = createViewModel(with: Constants.mockCountiesData)
            await viewModel.fetchCountries()
            XCTAssertNotNil(viewModel.allCountries)
            XCTAssertEqual(viewModel.allCountries.count, Constants.mockCountiesData.count)
            XCTAssertEqual(viewModel.allCountries.first?.name, Constants.mockCountiesData.first?.name)
        }
    }
    
    func testAddCountry() {
        Task { @MainActor in
            let viewModel = createViewModel(with: Constants.mockCountiesData)
            await viewModel.fetchCountries()
            let cdCountries = createMockCoreData(with: viewModel.allCountries, context: viewModel.context)
            if let countryToAdd = Constants.mockCountiesData.first {
                viewModel.addCountry(from: countryToAdd, cdCountries)
                XCTAssertTrue(viewModel.selectedCountries.contains(countryToAdd))
                XCTAssertTrue(cdCountries.first(where: { $0.id == countryToAdd.id })?.isSaved == true)
            }
        }
    }
    
    func testRemoveCountry() {
        Task { @MainActor in
            let viewModel = createViewModel(with: Constants.mockCountiesData)
            await viewModel.fetchCountries()
            if let countryToTest = Constants.mockCountiesData.first {
                let cdCountries = createMockCoreData(with: viewModel.allCountries, context: viewModel.context)
                // Add then Remove
                viewModel.addCountry(from: countryToTest, cdCountries)
                viewModel.removeCountry(from: countryToTest, cdCountries)
                XCTAssertFalse(viewModel.selectedCountries.contains(countryToTest))
                XCTAssertFalse(cdCountries.first(where: { $0.id == countryToTest.id })?.isSaved == true)
            }
        }
    }
    
    func testSetupDefaultCountry() {
        Task { @MainActor in
            let mockCountries = Constants.mockCountiesData
            let viewModel = createViewModel(with: mockCountries)
            // Ensure it behaves like first launch
            viewModel.hasLaunchedBefore = false
            viewModel.hasLocationChecked = true
            // Simulate fetch and setup core data
            await viewModel.fetchCountries()
            let cdCountries = createMockCoreData(with: viewModel.allCountries, context: viewModel.context)
            await viewModel.setupDefaultCountry(with: cdCountries)
            XCTAssertTrue(viewModel.hasLaunchedBefore)
            XCTAssertFalse(viewModel.selectedCountries.isEmpty)
            if let selected = viewModel.selectedCountries.first {
                XCTAssertTrue(cdCountries.contains(where: { $0.id == selected.id && $0.isSaved }))
            }
        }
    }
    
    func testFilteredCountries() {
        Task { @MainActor in
            let viewModel = createViewModel(with: Constants.mockCountiesData)
            await viewModel.fetchCountries()
            viewModel.searchText = "Albania"
            let filtered = viewModel.filteredCountries
            XCTAssertEqual(filtered.count, 1)
            XCTAssertEqual(filtered.first?.name, "Albania")
            // When: search text matches multiple
            viewModel.searchText = "A"
            let multiFiltered = viewModel.filteredCountries
            XCTAssertGreaterThanOrEqual(multiFiltered.count, 1)
            // When: search text matches none
            viewModel.searchText = "Zzz"
            let emptyFiltered = viewModel.filteredCountries
            XCTAssertEqual(emptyFiltered.count, 0)
        }
    }
    
}
