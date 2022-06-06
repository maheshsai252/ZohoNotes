//
//  Extension.swift
//  ZohoNotes
//
//  Created by Mahesh sai on 05/06/22.
//

import Foundation
import SwiftUI

extension Color {
    static func getColour(data: Data) -> Self {
        do {
            #if !os(macOS)
            return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)!)
            #else
            return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data)!)
            #endif
        } catch {
            print(error)
        }
        return .clear
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0.1...0.5),
            green: .random(in: 0.1...0.5),
            blue: .random(in: 0.1...0.5)
        )
    }
}
