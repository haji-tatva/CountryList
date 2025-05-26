//
//  AppSettings.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//


import Foundation

struct AppSettings {
    
    private enum Keys {
        static let hasLaunchedBefore = "hasLaunchedBefore"
        static let hasLocationChecked = "hasLocationChecked"
    }

    /// Checks and sets the first launch flag.
    static var isFirstLaunch: Bool {
        let isFirstTime = !UserDefaults.standard.bool(forKey: Keys.hasLaunchedBefore)
        if isFirstTime {
            UserDefaults.standard.set(true, forKey: Keys.hasLaunchedBefore)
        }
        return isFirstTime
    }
    
    /// Returns `true` only the first time location should be checked.
    static var shouldCheckLocation: Bool {
        let isFirstTime = !UserDefaults.standard.bool(forKey: Keys.hasLocationChecked)
        if isFirstTime {
            UserDefaults.standard.set(true, forKey: Keys.hasLocationChecked)
        }
        return isFirstTime
    }
    
}
