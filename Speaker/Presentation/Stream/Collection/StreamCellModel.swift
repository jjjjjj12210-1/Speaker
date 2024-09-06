import Foundation
import UIKit

struct StreamCellModel {
    var id = UUID()
    var title: String
    var image: UIImage
}

extension StreamCellModel: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: StreamCellModel, rhs: StreamCellModel) -> Bool {
      lhs.id == rhs.id
    }
}
