import SwiftUI

extension Color {
    static let blogBackground = Color(hex: "#eeece2")
    static let blogSurface = Color.white
    static let blogPrimary = Color(hex: "#2563eb")
    static let blogPrimaryHover = Color(hex: "#1d4ed8")
    static let blogPrimaryLight = Color(hex: "#eff6ff")
    static let blogText = Color(hex: "#1a1a2e")
    static let blogTextSecondary = Color(hex: "#6b7280")
    static let blogTextMuted = Color(hex: "#9ca3af")
    static let blogBorder = Color(hex: "#e5e7eb")
    static let blogBorderLight = Color(hex: "#f3f4f6")
    static let blogSuccess = Color(hex: "#10b981")
    static let blogWarning = Color(hex: "#f59e0b")
    static let blogDanger = Color(hex: "#ef4444")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        self.init(
            red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgbValue & 0x0000FF) / 255.0
        )
    }
}

extension Font {
    static let blogHeadingLarge = Font.custom("NotoSerifSC-Bold", size: 28, relativeTo: .title)
    static let blogHeading = Font.custom("NotoSerifSC-Bold", size: 22, relativeTo: .title2)
    static let blogHeadingSmall = Font.custom("NotoSerifSC-SemiBold", size: 18, relativeTo: .title3)
    static let blogBody = Font.system(size: 16)
    static let blogCaption = Font.system(size: 13)
    static let blogSmall = Font.system(size: 12)
}
