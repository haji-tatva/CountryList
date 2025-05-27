//
//  CDCurrency+CoreDataProperties.swift
//  CountryList
//
//  Created by MACM23 on 27/05/25.
//
//

import Foundation
import CoreData


extension CDCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCurrency> {
        return NSFetchRequest<CDCurrency>(entityName: "CDCurrency")
    }

    @NSManaged public var code: String?
    @NSManaged public var currencyName: String?
    @NSManaged public var toCountry: CDCountry?

}

extension CDCurrency : Identifiable {

}
