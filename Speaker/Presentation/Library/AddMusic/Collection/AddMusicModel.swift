import Foundation

struct AddMusicModel {
    var id = UUID()
    let title: String
    let subTitle: String
}

extension AddMusicModel: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: AddMusicModel, rhs: AddMusicModel) -> Bool {
      lhs.id == rhs.id
    }
}
