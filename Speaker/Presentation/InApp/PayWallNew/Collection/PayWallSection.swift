import Foundation

final class PayWallSection: Section<PayWallCellModel> {}

extension PayWallSection {

    static func allSections(_ prices: [String]) -> [PayWallSection] {
        return [ .init(title: "",
                       items: [PayWallCellModel(during: "1 YEAR", price: prices[0], ficha: ["• $2,08/month",
                                                                                           "• Billed annually"]),
                               PayWallCellModel(during: "1 WEEK", price: prices[1], ficha: ["• Billed every week"]),
                               PayWallCellModel(during: "1 MONTH", price: prices[2], ficha: ["• Billed every month"])])
        ]
    }
}
