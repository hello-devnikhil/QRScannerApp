import Foundation
import CoreData

protocol ScanHistoryRepositoryProtocol {
    func fetchHistory() throws -> [ScanHistoryItem]
    func searchHistory(query: String) throws -> [ScanHistoryItem]
    func saveScan(qrCode: String, productName: String?, isGenuine: Bool)
    func deleteScan(id: UUID)
}

class ScanHistoryRepository: ScanHistoryRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
    }
    
    func fetchHistory() throws -> [ScanHistoryItem] {
        let request: NSFetchRequest<ScanHistoryEntity> = NSFetchRequest(entityName: "ScanHistoryEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ScanHistoryEntity.scanDate, ascending: false)]
        
        let entities = try context.fetch(request)
        return entities.map { ScanHistoryItem(entity: $0) }
    }
    
    func searchHistory(query: String) throws -> [ScanHistoryItem] {
        if query.isEmpty { return try fetchHistory() }
        
        let request: NSFetchRequest<ScanHistoryEntity> = NSFetchRequest(entityName: "ScanHistoryEntity")
        request.predicate = NSPredicate(format: "productName CONTAINS[cd] %@ OR qrCode CONTAINS[cd] %@", query, query)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ScanHistoryEntity.scanDate, ascending: false)]
        
        let entities = try context.fetch(request)
        return entities.map { ScanHistoryItem(entity: $0) }
    }
    
    func saveScan(qrCode: String, productName: String?, isGenuine: Bool) {
        context.performAndWait {
            let entity = ScanHistoryEntity(context: context)
            entity.id = UUID()
            entity.qrCode = qrCode
            entity.productName = productName
            entity.scanDate = Date()
            entity.isGenuine = isGenuine
            
            CoreDataStack.shared.saveContext()
        }
    }
    
    func deleteScan(id: UUID) {
        context.performAndWait {
            let request: NSFetchRequest<ScanHistoryEntity> = NSFetchRequest(entityName: "ScanHistoryEntity")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                if let entityToDelete = try context.fetch(request).first {
                    context.delete(entityToDelete)
                    CoreDataStack.shared.saveContext()
                }
            } catch {
                print("Failed to delete scan: \(error)")
            }
        }
    }
}
