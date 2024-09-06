import Foundation

class AddMusicSection: Section<AddMusicModel> {}

extension AddMusicSection {

    static func allSections() -> [AddMusicSection] {
        return [ .init(title: "",
                       items: [AddMusicModel(title: "iPhone/iPad", subTitle: "Music files \ntransfering"),
                               AddMusicModel(title: "Files", subTitle: "Add music from \nfile manager"),
                               AddMusicModel(title: "Apple Music", subTitle: "Import music from \nApple Music"),
                               AddMusicModel(title: "Dropbox", subTitle: "Instruction to \ndownloading"),
                               AddMusicModel(title: "Google Drive", subTitle: "Instruction to \ndownloading"),
                               AddMusicModel(title: "OneBox", subTitle: "Instruction to \ndownloading")])
        ]
    }
}
