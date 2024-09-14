//
//  HomePresenter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol HomePresenterInterface {
    func viewDidLoad(withView view: HomePresenterOutputInterface)
    func selectWifi()
    func selectBluetooth()

    func selectVolume()
    func selectBass()
    func selectTreble()
}

final class HomePresenter: NSObject {

    private weak var view: HomePresenterOutputInterface?
    private var router: HomeRouterInterface

    init(router: HomeRouterInterface) {
        self.router = router
    }
}

// MARK: - HomePresenterInterface

extension HomePresenter: HomePresenterInterface {
    
    func selectVolume() {
        router.showVolume()
    }
    
    func selectBass() {
        router.showBass()
    }
    
    func selectTreble() {
        router.showTreble()
    }
    
    func selectBluetooth() {
        router.showBluetooth()
    }
    
    func selectWifi() {
        router.showWiFi()
    }
    
    func viewDidLoad(withView view: HomePresenterOutputInterface) {
        self.view = view
    }
}
