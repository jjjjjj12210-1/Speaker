import Foundation
import CoreData

final class Store {
    private init() {}
    private static let shared: Store = Store()

    lazy var container: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "SpeakerCD")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    // MARK: - APIs

    static var viewContext: NSManagedObjectContext { return shared.container.viewContext }

    static var newContext: NSManagedObjectContext { return shared.container.newBackgroundContext() }
}

extension Store {
    static func deleteAllCoreData() {
        let container = shared.container
        let storeContainer = container.persistentStoreCoordinator
        for store in container.persistentStoreDescriptions {
            if let url = store.url {
                do {
                    try storeContainer.destroyPersistentStore(at: url, ofType:  store.type, options: nil)
                    storeContainer.addPersistentStore(with: store) { _,_ in }
                } catch {
                    print("Attempted to clear persistent store: " + error.localizedDescription)
                }
            }
        }
    }
}
