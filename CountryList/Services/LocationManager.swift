//
//  LocationManager.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//

// MARK: - LocationManager

import CoreLocation
import Foundation

protocol LocationManagerImp: ObservableObject {
    var country: String? { get set }
    var isLocationLoading: Bool { get set }
    func requestPermissionAndLocation()
}

// MARK: - LocationManager
/// Handles location permission requests and resolves the user’s country name.
/// Publishes the detected country (or `""` if unavailable) and a loading flag.
final class LocationManager: NSObject, ObservableObject, LocationManagerImp {
    
    // MARK: Properties
    private let manager = CLLocationManager()
    
    /// The resolved country name (empty string if denied or failed).
    @Published var country: String? = nil
    
    /// Indicates whether a location lookup is currently in progress.
    @Published var isLocationLoading: Bool = false
    
    // MARK: Initializer
    override init() {
        super.init()
        manager.delegate = self
    }
    
    // MARK: Public API
    /// Request authorisation if needed, then attempt to fetch a location.
    func requestPermissionAndLocation() {
        isLocationLoading = true
        
        switch manager.authorizationStatus {
        case .notDetermined:
            // First-time request
            manager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Already authorised — fetch location immediately
            manager.requestLocation()
            
        default:
            // Denied / Restricted → fallback
            updateCountry(with: "")
        }
    }
    
    // MARK: Helpers
    private func updateCountry(with value: String) {
        DispatchQueue.main.async {
            self.country = value
            self.isLocationLoading = false
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    /// Called when locations are delivered.
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            updateCountry(with: "")
            return
        }
        
        // Reverse-geocode to resolve the country name.
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            let countryName = placemarks?.first?.country ?? ""
            self.updateCountry(with: countryName)
        }
    }
    
    /// Called when authorisation status changes.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
            
        case .denied, .restricted:
            updateCountry(with: "")
            
        default:
            break   // .notDetermined is handled elsewhere
        }
    }
    
    /// Called when the location manager fails.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateCountry(with: "")
    }
}
