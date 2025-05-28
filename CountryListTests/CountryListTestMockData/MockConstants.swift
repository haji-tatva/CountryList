//
//  MockConstants.swift
//  CountryList
//
//  Created by MACM23 on 28/05/25.
//

@testable import CountryList

enum Constants {
    static let mockCountiesData: [Country] = [
        Country(
            id: "AFG",
            name: "Afghanistan",
            capital: "Kabul",
            currencies: [
                Currency(code: "AFN", name: "Afghan afghani")
            ],
            flag: "https://restcountries.com/data/afg.svg",
            flags: nil
        ),
        Country(
            id: "ALB",
            name: "Albania",
            capital: "Tirana",
            currencies: [
                Currency(code: "ALL", name: "Albanian lek")
            ],
            flag: "https://restcountries.com/data/alb.svg",
            flags: nil
        ),
        Country(
            id: "DZA",
            name: "Algeria",
            capital: "Algiers",
            currencies: [
                Currency(code: "DZD", name: "Algerian dinar")
            ],
            flag: "https://restcountries.com/data/dza.svg",
            flags: nil
        ),
        Country(
            id: "AND",
            name: "Andorra",
            capital: "Andorra la Vella",
            currencies: [
                Currency(code: "EUR", name: "Euro")
            ],
            flag: "https://restcountries.com/data/and.svg",
            flags: nil
        ),
        Country(
            id: "AGO",
            name: "Angola",
            capital: "Luanda",
            currencies: [
                Currency(code: "AOA", name: "Angolan kwanza")
            ],
            flag: "https://restcountries.com/data/ago.svg",
            flags: nil
        )
    ]
}
