//
//  CountryService.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//


import Foundation

protocol CountryServiceImp {
    func fetchAllCountries() async throws -> [Country]
}

// MARK: - CountryService
/// Responsible for fetching country data from the REST Countries API.
class CountryService: CountryServiceImp {
    
    // MARK: Properties
    private let session: URLSession
    private let decoder: JSONDecoder
    
    // MARK: - Initializer
    /// Initializes the service with a URLSession and JSONDecoder.
    init(session: URLSession = .shared,
         decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    // MARK: - API Call
    /// Fetches the complete list of countries
    @MainActor
    func fetchAllCountries() async throws -> [Country] {
        guard let url = URL(string: Constants.URLs.countriesAPI) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await session.data(from: url)
        return try decoder.decode([Country].self, from: data)
    }
}
