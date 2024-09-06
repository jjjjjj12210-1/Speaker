import Foundation
import UIKit
import SystemConfiguration

enum PhoneSize {
    case small
    case medium
    case big
}

var phoneSize: PhoneSize = {
    let heightDevaice = UIScreen.main.bounds.size.height
    if heightDevaice < 700 {
        return .small
    } else if heightDevaice > 700 && heightDevaice < 900 {
        return .medium
    } else {
        return .big
    }
}()

let isSmallDevice = UIScreen.main.bounds.size.height < 700

let deviceHeight = UIScreen.main.bounds.size.height
let deviceWidth = UIScreen.main.bounds.size.width
