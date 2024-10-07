import Foundation
import UIKit

struct PayWallCellModel {
    let id = UUID()
    let during: String
    let price: String
    let ficha: [String]
}

extension PayWallCellModel: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: PayWallCellModel, rhs: PayWallCellModel) -> Bool {
      lhs.id == rhs.id
    }
}
