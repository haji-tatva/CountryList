//
//  CDFlags+CoreDataProperties.swift
//  CountryList
//
//  Created by MACM23 on 27/05/25.
//
//

import Foundation
import CoreData


extension CDFlags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFlags> {
        return NSFetchRequest<CDFlags>(entityName: "CDFlags")
    }

    @NSManaged public var png: String?
    @NSManaged public var svg: String?
    @NSManaged public var toCountry: CDCountry?

}

extension CDFlags : Identifiable {

}
