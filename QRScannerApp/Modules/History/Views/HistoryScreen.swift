import SwiftUI

struct HistoryScreen: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            if viewModel.historyItems.isEmpty && viewModel.searchQuery.isEmpty {
                emptyStateView
            } else {
                List {
                    ForEach(viewModel.historyItems) { item in
                        NavigationLink(destination: ProductDetailScreen(barcode: item.qrCode)) {
                            HistoryRow(item: item)
                        }
                        .listRowBackground(Theme.background)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .onDelete(perform: viewModel.deleteItem)
                }
                .listStyle(.plain)
                .searchable(text: $viewModel.searchQuery, prompt: "Search by product or QR code")
            }
        }
        .navigationTitle("Scan History")
        .onAppear {
            viewModel.fetchHistory()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 64))
                .foregroundColor(Theme.secondaryText)
            
            Text("No Scan History")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your scanned QR codes will appear here.")
                .foregroundColor(Theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct HistoryRow: View {
    let item: ScanHistoryItem
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(item.isGenuine ? Theme.success.opacity(0.2) : Theme.error.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: item.isGenuine ? "checkmark" : "xmark")
                        .foregroundColor(item.isGenuine ? Theme.success : Theme.error)
                        .font(.system(size: 20, weight: .bold))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.productName ?? "Unknown Product")
                    .font(.headline)
                    .foregroundColor(Theme.text)
                    .lineLimit(1)
                
                Text(item.qrCode)
                    .font(.caption)
                    .foregroundColor(Theme.secondaryText)
                    .lineLimit(1)
                
                Text(item.scanDate, style: .date)
                    .font(.caption2)
                    .foregroundColor(Theme.secondaryText)
            }
            
            Spacer()
        }
        .padding()
        .background(Theme.secondaryBackground)
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
