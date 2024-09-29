import Foundation
import CoreData

enum ResultCoreData {
    case success, fail(Error)
}

// MARK: - Save, Delete
extension NSManagedObjectContext {
    func save(completion: ((ResultCoreData) -> ())?) {
        do {
            try self.save()
            completion?(.success)
        } catch let error {
            self.rollback()
            completion?(.fail(error))
        }
    }

    func deleteItem(object: NSManagedObject?, completion: ((ResultCoreData) -> ())?) {
        guard let item = object else {return}
        perform {
            self.delete(item)
            self.save(completion: completion)
        }
    }
}

// MARK: - Methods

extension NSManagedObjectContext {

    // MARK: - Load data

    var audioDataSource: AudioMODataSource { return AudioMODataSource(context: self) }

    // MARK: - Data manupulation

    func addAudio(item: AudioTrack, completion: ((ResultCoreData) -> ())?) {

        var dataImg: Data? = nil
        if item.logo != nil {
            dataImg = item.logo!.pngData()
        }

        let urlString = item.isFile ? item.filePath?.lastPathComponent ?? "" : item.filePath?.absoluteString ?? ""
        perform {
            let entity: AudioMO = AudioMO(context: self)
            entity.id = item.id
            entity.date = item.date
            entity.artist = item.artist
            entity.title = item.titleTrack
            entity.logo = dataImg
            entity.url = urlString
            entity.isFile = item.isFile
            self.save(completion: completion)
        }
    }
}
