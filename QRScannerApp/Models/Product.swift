import Foundation

// Models based on Open Food Facts v2 API response
struct ProductResponse: Decodable {
    let status: Int
    let code: String?
    let product: Product?
}

struct Product: Decodable {
    let productName: String?
    let brands: String?
    let categories: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case categories
        case imageURL = "image_url"
    }
    
    var isGenuine: Bool {
        // Mock verification logic: if we have a valid product name, we consider it genuine.
        return productName != nil && !(productName?.isEmpty ?? true)
    }
}
