import SwiftUI

enum Theme {
    static let primary = Color.blue
    static let success = Color.green
    static let error = Color.red
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let text = Color.primary
    static let secondaryText = Color.secondary
    
    static let accentGradient = LinearGradient(
        colors: [Color.blue, Color.purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let successGradient = LinearGradient(
        colors: [Color.green, Color(red: 0.2, green: 0.8, blue: 0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cornerRadius: CGFloat = 16.0
    static let buttonHeight: CGFloat = 56.0
}
