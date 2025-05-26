//
//  CountryService.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//


import Foundation

// MARK: - CountryService
/// Responsible for fetching country data from the REST Countries API.
class CountryService {
    
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
    func fetchAllCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        // Validate and build the API URL
        guard let url = URL(string: Constants.URLs.countriesAPI) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        // Start the API call
        session.dataTask(with: url) { [decoder] data, _, error in
            // Handle error if any occurred during request
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            // Handle missing data scenario
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }

            // decode the country list
            do {
                let countries = try decoder.decode([Country].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(countries))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
}
