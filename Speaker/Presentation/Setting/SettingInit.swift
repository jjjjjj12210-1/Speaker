//
//  SettingInit.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

final class SettingInit {
    static func createViewController() -> UIViewController {
        let router = SettingRouter()
        let presenter = SettingPresenter(router: router)
        let viewController = SettingViewController(presenter: presenter,
                                                                     router: router)

        router.controller = viewController

        return viewController
    }
}
