//
//  APIError.swift
//  CountryList
//
//  Created by MACM23 on 27/05/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .invalidResponse: return "Invalid server response."
        case .decodingError: return "Failed to decode the data."
        }
    }
}
