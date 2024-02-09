//
//  UIColor+Ext.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-08.
//

import SwiftUI

extension Color {
    /// The color comes as hex string from the Unslash  API. This is used to conver to a Color object
    /// For inspiration behind the approach, read: https://blog.schurigeln.com/using-hex-color-values-in-swiftui/
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let rgbValue = UInt32(hex, radix: 16)
        let r = Double((rgbValue! & 0xFF0000) >> 16) / 255
        let g = Double((rgbValue! & 0x00FF00) >> 8) / 255
        let b = Double(rgbValue! & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
