import UIKit

final class AppCoordinator {

    private var window: UIWindow?

    func start() {
        if UserSettings.isUsualLaunch ?? false {
            showMain()
        } else {
            welcomeScene()
            UserSettings.countOfRate = 0
        }
    }

    func showPayWAll() {
        payWallScene()
    }

    func showMain() {
        mainScene()
    }

    private func welcomeScene() {
        let module = WelcomeViewController()
        showController(module)
    }

    private func payWallScene() {
        let module = PayWallInit.createViewController()
        showController(module)
    }

    private func mainScene() {
        let module = configureTabBarController()
        showController(module)
    }

    private func showController(_ controller: UIViewController) {
        let window = AppDelegate.appDelegate.window ?? UIWindow(frame: UIScreen.main.bounds)
        window.overrideUserInterfaceStyle = .light
        window.backgroundColor = .black
        AppDelegate.appDelegate.window = window

        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator {
    private func configureTabBarController() -> UITabBarController {
        let tabBarController = SpeakerTabBar()
        tabBarController.hidePlayer(true)
        tabBarController.viewControllers = [createVC(HomeInit.createViewController(),
                                                     icon: nil,
                                                     selctedImage: nil),
                                            createVC(LibraryInit.createViewController(),
                                                     icon: nil,
                                                     selctedImage: nil),
                                            createVC(StreamInit.createViewController(),
                                                     icon: nil,
                                                     selctedImage: nil),
                                            createVC(SettingInit.createViewController(),
                                                     icon: nil,
                                                     selctedImage: nil)
        ]
        return tabBarController
    }

    func createVC(_ vc: UIViewController, icon: UIImage?, selctedImage: UIImage?) -> UIViewController {
        let navigationController = SpeakerNavBar(rootViewController: vc)
        return navigationController
    }
}
