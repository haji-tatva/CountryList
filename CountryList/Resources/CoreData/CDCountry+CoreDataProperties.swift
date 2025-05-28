//
//  CDCountry+CoreDataProperties.swift
//  CountryList
//
//  Created by MACM23 on 27/05/25.
//
//

import Foundation
import CoreData


extension CDCountry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCountry> {
        return NSFetchRequest<CDCountry>(entityName: "CDCountry")
    }

    @NSManaged public var isSaved: Bool
    @NSManaged public var bestFlagURL: String?
    @NSManaged public var capital: String?
    @NSManaged public var flag: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var currencies: NSSet?
    @NSManaged public var flags: CDFlags?

}

// MARK: Generated accessors for currencies
extension CDCountry {

    @objc(addCurrenciesObject:)
    @NSManaged public func addToCurrencies(_ value: CDCurrency)

    @objc(removeCurrenciesObject:)
    @NSManaged public func removeFromCurrencies(_ value: CDCurrency)

    @objc(addCurrencies:)
    @NSManaged public func addToCurrencies(_ values: NSSet)

    @objc(removeCurrencies:)
    @NSManaged public func removeFromCurrencies(_ values: NSSet)

}

extension CDCountry : Identifiable {

}
