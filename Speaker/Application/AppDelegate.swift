import UIKit
import AVFAudio
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
        setAudioSession()
//        Store.deleteAllCoreData()
        AudioManager.shared.loadAllTrack()
//        AudioManager.shared.setAllTracks()
        return true
    }
}

extension AppDelegate {
    func setAudioSession() {
        do {
            // Настройка AVAudioSession для фонового воспроизведения
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
//                                                                                                 .allowAirPlay,
//                                                                                                 .allowBluetooth,
//                                                                                                 .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки AVAudioSession: \(error.localizedDescription)")
        }
    }
}
