//
//  CountryListApp.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//

import SwiftUI

@main
struct CountryListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SelectedCountriesView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
