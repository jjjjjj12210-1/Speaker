//
//  BluetoothMenuPresenter.swift
//  Speaker
//
//  Created by Денис Ледовский on 31.08.2024.
//

import UIKit

protocol BluetoothMenuPresenterInterface {
    func viewDidLoad(withView view: BluetoothMenuPresenterOutputInterface)
    func selectBack()
    func selectDevice(isConnect: Bool)
}

final class BluetoothMenuPresenter: NSObject {

    private weak var view: BluetoothMenuPresenterOutputInterface?
    private var router: BluetoothMenuRouterInterface

    init(router: BluetoothMenuRouterInterface) {
        self.router = router
    }
}

// MARK: - BluetoothMenuPresenterInterface

extension BluetoothMenuPresenter: BluetoothMenuPresenterInterface {
    func selectDevice(isConnect: Bool) {
        router.showBluetoothConnect(isConnect: isConnect)
    }
    
    func selectBack() {
        router.dismiss()
    }
    
    func viewDidLoad(withView view: BluetoothMenuPresenterOutputInterface) {
        self.view = view
    }
}
