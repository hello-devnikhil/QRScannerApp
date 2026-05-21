import SwiftUI

struct ProductDetailScreen: View {
    @StateObject private var viewModel: ProductDetailViewModel
    
    init(barcode: String) {
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(barcode: barcode))
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    switch viewModel.state {
                    case .loading:
                        ProgressView("Verifying Product...")
                            .padding(.top, 100)
                    case .loaded(let product):
                        productView(product)
                    case .unverified(let barcode):
                        unverifiedView(barcode: barcode)
                    case .error(let message):
                        errorView(message)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Verification Result")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchProductDetails()
        }
    }
    
    @ViewBuilder
    private func productView(_ product: Product) -> some View {
        VStack(spacing: 24) {
            // Verification Badge
            badgeView(isGenuine: true)
            
            // Image Card
            if let imageUrlString = product.imageURL, let url = URL(string: imageUrlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(Theme.cornerRadius)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.secondaryText)
                            .frame(height: 200)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.secondaryBackground)
                .cornerRadius(Theme.cornerRadius)
            }
            
            // Details Card
            VStack(alignment: .leading, spacing: 16) {
                detailRow(title: "Product Name", value: product.productName ?? "Unknown")
                detailRow(title: "Brand", value: product.brands ?? "Unknown")
                detailRow(title: "Category", value: product.categories ?? "Unknown")
            }
            .padding()
            .background(Theme.secondaryBackground)
            .cornerRadius(Theme.cornerRadius)
        }
    }
    
    @ViewBuilder
    private func unverifiedView(barcode: String) -> some View {
        VStack(spacing: 24) {
            badgeView(isGenuine: false)
            
            VStack(alignment: .leading, spacing: 16) {
                detailRow(title: "QR Code", value: barcode)
                detailRow(title: "Status", value: "Not found in database")
            }
            .padding()
            .background(Theme.secondaryBackground)
            .cornerRadius(Theme.cornerRadius)
            
            Text("This product could not be verified. It might be counterfeit or not registered in our database.")
                .font(.subheadline)
                .foregroundColor(Theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
        }
    }
    
    @ViewBuilder
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(Theme.error)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .foregroundColor(Theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 100)
    }
    
    @ViewBuilder
    private func badgeView(isGenuine: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: isGenuine ? "checkmark.seal.fill" : "xmark.seal.fill")
                .font(.system(size: 32))
            
            Text(isGenuine ? "Genuine Product" : "Unverified")
                .font(.title3)
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(isGenuine ? Theme.successGradient : LinearGradient(colors: [Theme.error, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: (isGenuine ? Theme.success : Theme.error).opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.secondaryText)
                .textCase(.uppercase)
            
            Text(value)
                .font(.body)
                .foregroundColor(Theme.text)
                .fontWeight(.medium)
        }
    }
}
