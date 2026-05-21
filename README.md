# QRScannerApp
# QR Code Scanner & Product Verification

A robust, production-ready iOS application built to scan QR codes, fetch product verification details from an API, and store scan history offline. This app is designed using modern iOS development standards.

## Architecture Overview

This project is built using a clean **MVVM (Model-View-ViewModel)** architecture with a strong emphasis on Protocol-Oriented Programming and Dependency Injection. The presentation layer uses **SwiftUI** for a declarative, reactive UI, while the persistence layer is powered by **CoreData**.

### Why SwiftUI + MVVM?

1. **Declarative UI**: SwiftUI allows us to build complex, responsive user interfaces with significantly less code than UIKit. It natively supports dark mode, dynamic type, and fluid animations.
2. **Reactive State Management**: MVVM pairs perfectly with SwiftUI. By using `@StateObject` and `@Published`, the UI automatically updates whenever the underlying data changes, reducing boilerplate code and state-mismatch bugs.
3. **Testability**: Extracting business logic, networking, and data formatting into ViewModels (which have their dependencies injected via protocols) makes the core logic highly unit-testable.

## Folder Structure

The project follows a scalable, feature-based module structure:

- `App/`: Contains the main entry point `QRScannerAppApp.swift` and `ContentView.swift`.
- `Models/`: Data structures defining the domain models (`Product`, `ScanHistoryItem`).
- `Modules/`: Feature-based directories containing the Views and ViewModels.
  - `Scanner/`: The camera preview, permissions, and barcode processing.
  - `ProductDetail/`: Displays product information and verification badges.
  - `History/`: Lists past scans with debounced searching.
- `Networking/`: Generic, protocol-based networking layer using `async/await`.
- `Persistence/`: CoreData stack and repositories managing offline data storage.
- `Utilities/`: Extensions and shared components (e.g., `Theme.swift` for design tokens).

## Libraries Used

- **Foundation / AVFoundation**: For generic data handling and raw camera capture.
- **SwiftUI / Combine**: For UI layout, navigation, state management, and debounced search streams.
- **CoreData**: For robust, offline persistence (chosen over SwiftData to strictly satisfy the iOS 16+ minimum target requirement).
- *No third-party libraries were used*, minimizing external dependencies and showcasing raw iOS SDK capabilities.

## Trade-offs

- **CoreData vs. SwiftData**: SwiftData is more modern for SwiftUI apps, but it requires iOS 17+. I opted for CoreData to ensure full compatibility with the requested minimum iOS 16 requirement. The CoreData stack is created programmatically, which is highly scalable and eliminates the `.xcdatamodeld` file merging overhead for large teams.
- **`AVCaptureSession` vs. VisionKit `DataScannerViewController`**: VisionKit is fantastic, but wrapping raw `AVFoundation` within a `UIViewRepresentable` provides greater control over the custom scanning overlay, haptics, and precise metadata handling required for this specific use case.

## Assumptions

- The `Open Food Facts` API (v2) is used as the primary verification backend. It returns sufficient data to demonstrate genuine vs. unverified status based on the existence of a valid product name.
- If the API fails or the barcode is not found, the app gracefully degrades to an "Unverified" state while still saving the offline record.

## Known Limitations

- **Camera Simulator Limitation**: The iOS simulator does not support the camera hardware. To fully test the QR scanning feature, the app must be deployed to a physical device.

## Future Improvements

- **Unit Testing**: Implement `XCTestCase` suites for the ViewModels by mocking `NetworkServiceProtocol` and `ScanHistoryRepositoryProtocol`.
- **Image Caching Layer**: Add a custom `URLCache` configuration or a lightweight image cache manager if `AsyncImage` default caching is insufficient for high-volume offline reading.
- **CoreData Migration**: Implement lightweight migrations if the CoreData schema evolves in the future.

## Setup Instructions

1. Clone the repository.
2. Open `QRScannerApp.xcodeproj` in Xcode 15 or later.
3. Connected physical device (iOS 16.0+).
4. Run the project (`Cmd + R`).

## Time Spent

- **Planning & Architecture:** 1 hour
- **UI Migration to SwiftUI:** 1.5 hours
- **Networking & Concurrency Refactor:** 1 hour
- **Persistence Wiring & Polish:** 1 hour
- **Total Time:** ~4.5 hours
