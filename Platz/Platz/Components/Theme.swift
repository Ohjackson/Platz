//
//  Theme.swift
//  Platz
//
//  Design System - Colors, Typography, and Styles
//

import SwiftUI

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Theme Colors
struct PlatzColors {
    // Background Colors
    static let background = Color(hex: "0B0F14")
    static let surface = Color(hex: "111827")
    static let surfaceRaised = Color(hex: "161F2C")
    static let border = Color(hex: "223044")
    
    // Text Colors
    static let textPrimary = Color(hex: "E7EEF9")
    static let textSecondary = Color(hex: "B6C2D6")
    static let textMuted = Color(hex: "7C8AA5")
    
    // Primary (German Gold)
    static let primary = Color(hex: "F2C14E")
    static let primaryHover = Color(hex: "F5CC68")
    static let primaryPressed = Color(hex: "DCA93D")
    static let onPrimary = Color(hex: "111827")
    
    // Accent Colors
    static let link = Color(hex: "7AA7FF")
    static let tag = Color(hex: "2A3A55")
    static let tagText = Color(hex: "B6C2D6")
    
    // Navigation
    static let navBackground = Color(hex: "0A0D12")
    static let navActive = Color(hex: "F2C14E")
    static let navInactive = Color(hex: "7C8AA5")
    
    // Semantic Colors
    static let success = Color(hex: "4ADE80")
    static let error = Color(hex: "F87171")
    static let warning = Color(hex: "FBBF24")
}

// MARK: - Theme Typography
struct PlatzTypography {
    // Large Title
    static let largeTitle = Font.system(size: 34, weight: .bold)
    
    // Title
    static let title1 = Font.system(size: 28, weight: .bold)
    static let title2 = Font.system(size: 22, weight: .bold)
    static let title3 = Font.system(size: 20, weight: .semibold)
    
    // Body
    static let bodyLarge = Font.system(size: 17, weight: .regular)
    static let body = Font.system(size: 15, weight: .regular)
    static let bodyBold = Font.system(size: 15, weight: .semibold)
    
    // Caption
    static let caption = Font.system(size: 13, weight: .regular)
    static let captionBold = Font.system(size: 13, weight: .semibold)
    
    // Button
    static let button = Font.system(size: 16, weight: .semibold)
    static let buttonSmall = Font.system(size: 14, weight: .medium)
    
    // Quote (German)
    static let quote = Font.system(size: 24, weight: .medium, design: .serif)
    static let quoteSmall = Font.system(size: 18, weight: .regular, design: .serif)
}

// MARK: - Theme Spacing
struct PlatzSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Theme Radius
struct PlatzRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xl: CGFloat = 20
    static let full: CGFloat = 9999
}

// MARK: - View Modifiers
struct PlatzCardStyle: ViewModifier {
    var isRaised: Bool = false
    
    func body(content: Content) -> some View {
        content
            .background(isRaised ? PlatzColors.surfaceRaised : PlatzColors.surface)
            .cornerRadius(PlatzRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: PlatzRadius.large)
                    .stroke(PlatzColors.border, lineWidth: 1)
            )
    }
}

struct PlatzPrimaryButtonStyle: ButtonStyle {
    var isFullWidth: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(PlatzTypography.button)
            .foregroundColor(PlatzColors.onPrimary)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, PlatzSpacing.lg)
            .padding(.vertical, PlatzSpacing.sm)
            .background(
                configuration.isPressed ? PlatzColors.primaryPressed : PlatzColors.primary
            )
            .cornerRadius(PlatzRadius.medium)
    }
}

struct PlatzSecondaryButtonStyle: ButtonStyle {
    var isFullWidth: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(PlatzTypography.button)
            .foregroundColor(PlatzColors.primary)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, PlatzSpacing.lg)
            .padding(.vertical, PlatzSpacing.sm)
            .background(PlatzColors.surfaceRaised)
            .cornerRadius(PlatzRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: PlatzRadius.medium)
                    .stroke(PlatzColors.border, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

// MARK: - View Extensions
extension View {
    func platzCard(raised: Bool = false) -> some View {
        modifier(PlatzCardStyle(isRaised: raised))
    }
}
