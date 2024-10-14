//
//  HomePresenter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit
import StoreKit

protocol HomePresenterInterface {
    func viewDidLoad(withView view: HomePresenterOutputInterface)
    func selectWifi()

    func selectVolume()
    func selectBass()
    func selectTreble()
    func openBluetoothSettings()

    func selectHowConnect()
}

final class HomePresenter: NSObject {

    private weak var view: HomePresenterOutputInterface?
    private var router: HomeRouterInterface

    init(router: HomeRouterInterface) {
        self.router = router
    }
}

private extension HomePresenter {
    func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
// MARK: - HomePresenterInterface

extension HomePresenter: HomePresenterInterface {
    func selectHowConnect() {
        router.showHowConnect()
    }

    func openBluetoothSettings() {
        if let url = URL(string: "App-Prefs:Bluetooth") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Не удалось открыть меню Bluetooth")
            }
        }
    }

    func selectVolume() {
        router.showVolume()
    }
    
    func selectBass() {
        router.showBass()
    }
    
    func selectTreble() {
        router.showTreble()
    }

    
    func selectWifi() {
        router.showWiFi()
    }
    
    func viewDidLoad(withView view: HomePresenterOutputInterface) {
        self.view = view

        if UserSettings.countOfRate == 3 {
            UserSettings.countOfRate = 0
            rateApp()
        }

        if let count = UserSettings.countOfRate {
            let newCount = count + 1
            UserSettings.countOfRate = newCount
        }
    }
}
