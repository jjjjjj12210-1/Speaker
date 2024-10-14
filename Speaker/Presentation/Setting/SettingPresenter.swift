import UIKit
import StoreKit

protocol SettingPresenterInterface {
    func viewDidLoad(withView view: SettingPresenterOutputInterface)
    func selectDevice()
    func shareApp()
    func rateApp()
    func selectSupport()
    func selectPP()
    func selectTerm()
}

final class SettingPresenter: NSObject {

    private weak var view: SettingPresenterOutputInterface?
    private var router: SettingRouterInterface

    init(router: SettingRouterInterface) {
        self.router = router
    }
}

// MARK: - SettingPresenterInterface

extension SettingPresenter: SettingPresenterInterface {

    func selectPP() {
        guard let url = AppData.policyURL else {
          return
        }
        UIApplication.shared.open(url)
    }

    func selectTerm() {
        guard let url = AppData.termsURL else {
          return
        }
        UIApplication.shared.open(url)
    }
    
    func selectSupport() {
        router.showMail()
    }

    func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func shareApp() {
        router.showShare()
    }
    
    func selectDevice() {
        if let url = URL(string: "App-Prefs:Bluetooth") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Не удалось открыть меню Bluetooth")
            }
        }
    }
    
    func viewDidLoad(withView view: SettingPresenterOutputInterface) {
        self.view = view
    }
}
