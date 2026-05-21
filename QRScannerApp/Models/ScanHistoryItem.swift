import Foundation

struct ScanHistoryItem: Identifiable, Equatable {
    let id: UUID
    let qrCode: String
    let productName: String?
    let scanDate: Date
    let isGenuine: Bool
    
    // Mapping from NSManagedObject
    init(entity: ScanHistoryEntity) {
        self.id = entity.id
        self.qrCode = entity.qrCode
        self.productName = entity.productName
        self.scanDate = entity.scanDate
        self.isGenuine = entity.isGenuine
    }
    
    init(id: UUID = UUID(), qrCode: String, productName: String?, scanDate: Date = Date(), isGenuine: Bool) {
        self.id = id
        self.qrCode = qrCode
        self.productName = productName
        self.scanDate = scanDate
        self.isGenuine = isGenuine
    }
}
