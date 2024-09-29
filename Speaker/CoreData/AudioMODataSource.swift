import CoreData

class AudioMODataSource {

    let controller: NSFetchedResultsController<NSFetchRequestResult>
    let request: NSFetchRequest<NSFetchRequestResult> = AudioMO.fetchRequest()

    let defaultSort: NSSortDescriptor = NSSortDescriptor(key: #keyPath(AudioMO.date), ascending: false)

    init(context: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor] = []) {
        var sort: [NSSortDescriptor] = sortDescriptors
        if sort.isEmpty { sort = [defaultSort] }

        request.sortDescriptors = sort

        controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }

    // MARK: - DataSource APIs

    func fetch(completion: ((ResultCoreData) -> ())?) {
        self.request.predicate = nil
        do {
            try controller.performFetch()
            completion?(.success)
        } catch let error {
            completion?(.fail(error))
        }
    }

    func fetchTrack(url: String, completion: ((ResultCoreData) -> ())?) {
        let predicate = NSPredicate(format: "url == %@", url)
        self.request.predicate = predicate
        do {
            try controller.performFetch()
            completion?(.success)
        } catch let error {
            completion?(.fail(error))
        }
    }

    var count: Int { return controller.fetchedObjects?.count ?? 0 }

    func getAudioList() -> [AudioMO] {
        guard let data: [AudioMO] = controller.fetchedObjects as? [AudioMO] else {return []}
        return data
    }
}
