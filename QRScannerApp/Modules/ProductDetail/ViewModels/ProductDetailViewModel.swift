import Foundation
import Combine

enum ProductDetailState {
    case loading
    case loaded(Product)
    case error(String)
    case unverified(String) // For cases where API fails but we still want to show it's unverified
}

@MainActor
class ProductDetailViewModel: ObservableObject {
    
    @Published var state: ProductDetailState = .loading
    
    private let barcode: String
    private let networkService: NetworkServiceProtocol
    private let repository: ScanHistoryRepositoryProtocol
    
    init(barcode: String, 
         networkService: NetworkServiceProtocol = NetworkService.shared,
         repository: ScanHistoryRepositoryProtocol = ScanHistoryRepository()) {
        self.barcode = barcode
        self.networkService = networkService
        self.repository = repository
    }
    
    func fetchProductDetails() async {
        state = .loading
        
        guard let url = APIEndpoints.verifyProduct(barcode: barcode) else {
            state = .error("Invalid API URL")
            return
        }
        
        do {
            let response: ProductResponse = try await networkService.request(url: url)
            
            if let product = response.product, product.isGenuine {
                self.state = .loaded(product)
                self.saveScan(productName: product.productName, isGenuine: true)
            } else {
                // Product not found or missing essential details
                self.state = .unverified(self.barcode)
                self.saveScan(productName: "Unknown Product", isGenuine: false)
            }
        } catch {
            // Network failure or decoding error - treat as unverified to gracefully handle API failures
            self.state = .unverified(self.barcode)
            self.saveScan(productName: "Verification Failed", isGenuine: false)
        }
    }
    
    private func saveScan(productName: String?, isGenuine: Bool) {
        repository.saveScan(qrCode: barcode, productName: productName, isGenuine: isGenuine)
    }
}
