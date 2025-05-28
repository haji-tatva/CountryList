//
//  APIService+Mock.swift
//  CountryList
//
//  Created by MACM23 on 27/05/25.
//

import XCTest
@testable import CountryList

final class APIServiceMock: CountryServiceImp {
    
    private let mockCountriesData: [Country]
    private let throwError: Bool
    
    init(mockCountriesData: [Country], throwError: Bool = false) {
        self.mockCountriesData = mockCountriesData
        self.throwError = throwError
    }
    
    func fetchAllCountries() async throws -> [Country] {
        if throwError {
            throw APIError.invalidResponse
        }
        return mockCountriesData
    }
}
