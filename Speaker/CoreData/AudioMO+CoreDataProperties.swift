//
//  AudioMO+CoreDataProperties.swift
//  Speaker
//
//  Created by Денис Ледовский on 22.09.2024.
//
//

import Foundation
import CoreData


extension AudioMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AudioMO> {
        return NSFetchRequest<AudioMO>(entityName: "AudioMO")
    }

    @NSManaged public var id: UUID
    @NSManaged public var url: String
    @NSManaged public var artist: String?
    @NSManaged public var title: String?
    @NSManaged public var logo: Data?
    @NSManaged public var date: Date
    @NSManaged public var isFile: Bool

    public var wrappedTitle: String {
        title ?? "Unknown"
    }

    public var wrappedArtist: String {
        artist ?? "Unknown"
    }

}

extension AudioMO : Identifiable {

}
