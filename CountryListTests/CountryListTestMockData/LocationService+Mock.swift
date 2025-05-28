//
//  LocationService+Mock.swift
//  CountryList
//
//  Created by MACM23 on 27/05/25.
//


import Foundation
import CoreLocation
@testable import CountryList

final class LocationServiceMock: LocationManagerImp {

    var country: String?
    var isLocationLoading: Bool
    
    init(country: String? = nil, isLocationLoading: Bool) {
        self.country = country
        self.isLocationLoading = isLocationLoading
    }
    
    func requestPermissionAndLocation() {
        isLocationLoading = false
    }
}

