//
//  PayWallInit.swift
//  Speaker
//
//  Created by Денис Ледовский on 27.08.2024.
//

import UIKit

final class PayWallInit {
    static func createViewController() -> UIViewController {
        let router = PayWallRouter()
        let presenter = PayWallPresenter(router: router)
        let viewController = PayWallViewController(presenter: presenter, router: router)

        router.controller = viewController

        return viewController
    }
}
