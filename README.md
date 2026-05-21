# QRScannerApp

An iOS application to scan QR codes, fetch product details from API, and save scan history offline.

---

## Features

- QR Code Scanning using AVFoundation
- Product Verification API Integration
- Offline Scan History
- Search Functionality
- Clean SwiftUI UI
- MVVM Architecture
- CoreData Persistence

---

## Architecture

The project follows **MVVM (Model-View-ViewModel)** architecture using **SwiftUI**.

Why MVVM?
- Better code separation
- Easy to maintain
- Scalable structure
- Improved testability

---

## Tech Stack

- Swift
- SwiftUI
- AVFoundation
- URLSession
- CoreData

---

## Folder Structure

- `Modules/`
  - Scanner
  - ProductDetail
  - History
- `Networking/`
- `Persistence/`
- `Models/`
- `Utilities/`

---

## API Used

Open Food Facts API was used for product verification.

Example:
```bash
https://world.openfoodfacts.org/api/v2/product/{barcode}
```

---

## Offline Support

All successful scans are stored locally using CoreData so history is available offline.

---

## Search Functionality

Users can search scan history using:
- Product name
- QR code value

---

## Libraries Used

No third-party libraries were used.

---

## Known Limitations

- QR scanning works best on a physical device.
- Camera is not fully supported in iOS Simulator.

---

## Future Improvements

- Add Unit Tests
- Better Error Handling
- Image Caching
- Filter by Verification Status

---

## Setup Instructions

1. Clone the repository
2. Open project in Xcode
3. Run on simulator or physical device
4. Allow camera permission

---

## Minimum Requirements

- Xcode 15+
- iOS 16+

---

## Time Spent

Approximately 4–5 hours.
