import Foundation

final class UserSettings {

    private enum SettingsKeys: String {
        case isUsualLaunch
        case countOfRate
    }

    static var isUsualLaunch: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.isUsualLaunch.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.isUsualLaunch.rawValue
            if let flag = newValue {
                defaults.set(flag, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }

    static var countOfRate: Int? {
        get {
            return UserDefaults.standard.integer(forKey: SettingsKeys.countOfRate.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.countOfRate.rawValue
            if let flag = newValue {
                defaults.set(flag, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}

