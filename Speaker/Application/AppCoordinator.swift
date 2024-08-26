import UIKit

final class AppCoordinator {

    private var window: UIWindow?

    func start() {
        welcomeScene()
    }

    private func welcomeScene() {
        let module = ViewController()
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
