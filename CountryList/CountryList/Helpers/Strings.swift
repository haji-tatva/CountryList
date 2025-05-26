//
//  Strings.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//

import Foundation

extension String {
    
    enum SelectedCountries {
        static let navigationTitle = "Countries"
        static let headerTitle = "Selected Countries"
        static let searchBtnTitle = "Search Country"
        static let progressTitle = "Fetching location…"
        static let nocountriesAdded = "No countries added yet."
    }
    
    enum DetailView {
        static let navigationTitle = "Country Details"
        static let countryName = "Country Name:"
        static let capitalName = "Capital:"
        static let currencyName = "Currency:"
    }
    
    enum CountrySearchView {
        static let navigationTitle = "Country Search"
        static let searchForACountry = "Search for a country"
        static let capitalName = "Capital:"
        static let currencyName = "Currency:"
    }
}
