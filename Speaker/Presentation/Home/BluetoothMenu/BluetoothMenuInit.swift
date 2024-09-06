//
//  BluetoothMenuInit.swift
//  Speaker
//
//  Created by Денис Ледовский on 31.08.2024.
//

import UIKit

final class BluetoothMenuInit {
    static func createViewController() -> UIViewController {
        let router = BluetoothMenuRouter()
        let presenter = BluetoothMenuPresenter(router: router)
        let viewController = BluetoothMenuViewController(presenter: presenter,
                                                                     router: router)

        router.controller = viewController

        return viewController
    }
}
