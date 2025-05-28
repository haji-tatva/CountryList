//
//  ImageCache.swift
//  CountryList
//
//  Created by MACM23 on 28/05/25.
//

import Foundation
import SwiftUI

class ImageCache {
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
