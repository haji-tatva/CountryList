//
//  Country.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//



import Foundation

struct Country: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let capital: String?
    let currencies: [Currency]?
    let flag: String?
    let flags: Flags?
    
    private enum CodingKeys: String, CodingKey {
        case id = "alpha3Code"
        case name, capital, currencies, flag, flags
    }
    
    var bestFlagURL: String? {
        if let png = flags?.png, !png.isEmpty {
            return png
        }
        if let svg = flags?.svg, !svg.isEmpty {
            return svg
        }
        if let flag = flag, !flag.isEmpty {
            return flag
        }
        return nil
    }
}

struct Flags: Codable, Equatable, Hashable {
    let svg: String?
    let png: String?
}

struct Currency: Codable, Equatable, Hashable {
    let code: String?
    let name: String?
}

