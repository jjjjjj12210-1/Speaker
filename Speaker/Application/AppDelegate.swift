import UIKit
import AVFAudio
import SnapKit
import ApphudSDK

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
        AudioSessionManager.shared.start()
        AudioManager.shared.loadAllTrack()
        Task {
            Apphud.start(apiKey: AppData.appHubKey)
            AppHubManager.shared.getProducts()
        }
        return true
    }
}
