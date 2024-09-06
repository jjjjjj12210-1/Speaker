import Foundation
import UIKit

enum FontFamily {
    case poppins
    case golos

    var prefix: String {
        switch self {
        case .poppins:
            return "Poppins-"
        case .golos:
            return "GolosText-"
        }
    }
}

private func customFont(_ type: UIFont.Weight = .regular,
                        size: CGFloat,
                        fontFamily: FontFamily) -> UIFont {
    var typeString = ""

    switch type {
    case .black:
        typeString = "Black"
    case .bold:
        typeString = "Bold"
    case .medium:
        typeString = "Medium"
    case .regular:
        typeString = "Regular"
    case .semibold:
        typeString = "SemiBold"
    case .thin:
        typeString = "Thin"
    case .light:
        typeString = "Light"
    case .ultraLight:
        typeString = "ExtraLight"
    case .heavy:
        typeString = "ExtraBold"
    default:
        return UIFont.systemFont(ofSize: size)
    }

    let fontName = fontFamily.prefix + typeString
    let font: UIFont = UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: type)
    return font
}

extension UIFont {

    static func custom(_ type: UIFont.Weight = .regular,
                       size: CGFloat,
                       fontFamily: FontFamily = .poppins) -> UIFont {
        return customFont(type, size: size, fontFamily: fontFamily)
    }

    static func golos(_ type: UIFont.Weight = .regular,
                      size: CGFloat) -> UIFont {
        return customFont(type, size: size, fontFamily: .golos)
    }

    static func poppins(_ type: UIFont.Weight = .regular,
                        size: CGFloat) -> UIFont {
        return customFont(type, size: size, fontFamily: .poppins)
    }
}
