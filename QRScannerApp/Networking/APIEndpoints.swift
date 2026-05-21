import Foundation

enum APIEndpoints {
    // We will use Open Food Facts API as a public mock API
    // https://world.openfoodfacts.org/api/v2/product/[barcode].json
    static let baseURL = "https://world.openfoodfacts.org/api/v2/product/"
    
    static func verifyProduct(barcode: String) -> URL? {
        return URL(string: "\(baseURL)\(barcode).json")
    }
}
