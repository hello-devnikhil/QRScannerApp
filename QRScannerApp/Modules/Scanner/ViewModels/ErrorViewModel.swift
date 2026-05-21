import Foundation
import SwiftUI

/// A simple error model that can be presented as an alert.
struct AppError: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

/// Centralised error handling view‑model used across the app.
@MainActor
final class ErrorViewModel: ObservableObject {
    @Published var currentError: AppError?

    /// Show an error with a title and message.
    func showError(title: String = "Error", message: String) {
        currentError = AppError(title: title, message: message)
    }

    /// Dismiss the currently presented error.
    func dismiss() {
        currentError = nil
    }
}
