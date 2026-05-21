import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        // We will create the schema programmatically or expect the user to create the xcdatamodeld
        // Since we can't easily generate the binary xcdatamodeld files without xml generation complexities,
        // we will create the NSManagedObjectModel programmatically to avoid any setup overhead for the user.
        
        let model = NSManagedObjectModel()
        
        let historyEntity = NSEntityDescription()
        historyEntity.name = "ScanHistoryEntity"
        historyEntity.managedObjectClassName = NSStringFromClass(ScanHistoryEntity.self)
        
        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .UUIDAttributeType
        idAttr.isOptional = false
        
        let qrCodeAttr = NSAttributeDescription()
        qrCodeAttr.name = "qrCode"
        qrCodeAttr.attributeType = .stringAttributeType
        qrCodeAttr.isOptional = false
        
        let productNameAttr = NSAttributeDescription()
        productNameAttr.name = "productName"
        productNameAttr.attributeType = .stringAttributeType
        productNameAttr.isOptional = true
        
        let scanDateAttr = NSAttributeDescription()
        scanDateAttr.name = "scanDate"
        scanDateAttr.attributeType = .dateAttributeType
        scanDateAttr.isOptional = false
        
        let isGenuineAttr = NSAttributeDescription()
        isGenuineAttr.name = "isGenuine"
        isGenuineAttr.attributeType = .booleanAttributeType
        isGenuineAttr.isOptional = false
        
        historyEntity.properties = [idAttr, qrCodeAttr, productNameAttr, scanDateAttr, isGenuineAttr]
        model.entities = [historyEntity]
        
        let container = NSPersistentContainer(name: "QRScannerApp", managedObjectModel: model)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// Defining the NSManagedObject programmatically to avoid needing a .xcdatamodeld file setup by the user
@objc(ScanHistoryEntity)
public class ScanHistoryEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var qrCode: String
    @NSManaged public var productName: String?
    @NSManaged public var scanDate: Date
    @NSManaged public var isGenuine: Bool
}
