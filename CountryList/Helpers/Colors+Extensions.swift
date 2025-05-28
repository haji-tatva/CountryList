//
//  Colors+Extensions.swift
//  CountryList
//
//  Created by MACM23 on 26/05/25.
//

import SwiftUI

// MARK: - Hex Color Extension for SwiftUI
extension Color {
    
    /// Create a SwiftUI Color from a hex string like "#FF5733" or "FF5733"
    init(hex: String, alpha: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RRGGBB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0) // Default to yellow for invalid hex
        }

        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: alpha)
    }
    
    // MARK: - Custom Colors
    enum CustomColors {
        static let header = Color(hex: "#63605D")
        static let appSecondary = Color(hex: "#FF6B6B")
        static let appBackground = Color(hex: "#F5F5F5")
    }
}

