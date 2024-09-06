import UIKit
import SnapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appCoordinator = AppCoordinator()
    var window: UIWindow?

    static var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("not open appdelegate")
        }
        return appDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appCoordinator.start()
        return true
    }
}
