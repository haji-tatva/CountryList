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
    
    func testFetchAllCountries() {
        Task { @MainActor in
            let viewModel = createViewModel(with: Constants.mockCountiesData)
            await viewModel.fetchCountries()
            XCTAssertNotNil(viewModel.allCountries)
            XCTAssertEqual(viewModel.allCountries.count, Constants.mockCountiesData.count)
            XCTAssertEqual(viewModel.allCountries.first?.name, Constants.mockCountiesData.first?.name)
        }
    }
    
}
