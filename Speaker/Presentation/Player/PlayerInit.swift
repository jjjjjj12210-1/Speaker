//
//  PlayerInit.swift
//  Speaker
//
//  Created by Денис Ледовский on 05.09.2024.
//

import UIKit

final class PlayerInit {
    static func createViewController() -> UIViewController {
        let router = PlayerRouter()
        let presenter = PlayerPresenter(router: router)
        let viewController = PlayerViewController(presenter: presenter,
                                                                     router: router)

        router.controller = viewController

        return viewController
    }
}
