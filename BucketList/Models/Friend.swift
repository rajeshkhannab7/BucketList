import Foundation
import SwiftData
import SwiftUI

@Model
final class Friend {
    var id: UUID
    var name: String
    var username: String
    var colorHex: String
    var addedDate: Date

    init(name: String, username: String, colorHex: String = "007AFF") {
        self.id = UUID()
        self.name = name
        self.username = username
        self.colorHex = colorHex
        self.addedDate = Date()
    }

    var color: Color {
        Color(hex: colorHex) ?? .blue
    }

    var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        guard hexSanitized.count == 6 else { return nil }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}
