import Foundation
import Combine

@MainActor
class HistoryViewModel: ObservableObject {
    
    @Published var historyItems: [ScanHistoryItem] = []
    @Published var searchQuery: String = ""
    
    private let repository: ScanHistoryRepositoryProtocol
    private var allItems: [ScanHistoryItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: ScanHistoryRepositoryProtocol = ScanHistoryRepository()) {
        self.repository = repository
        
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    func fetchHistory() {
        do {
            let items = try repository.fetchHistory()
            self.allItems = items
            self.performSearch(query: self.searchQuery)
        } catch {
            print("Failed to fetch history: \(error)")
        }
    }
    
    private func performSearch(query: String) {
        if query.isEmpty {
            historyItems = allItems
        } else {
            do {
                historyItems = try repository.searchHistory(query: query)
            } catch {
                print("Search failed: \(error)")
            }
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = historyItems[index]
            repository.deleteScan(id: item.id)
            
            if let allIndex = allItems.firstIndex(where: { $0.id == item.id }) {
                allItems.remove(at: allIndex)
            }
        }
        historyItems.remove(atOffsets: offsets)
    }
}
