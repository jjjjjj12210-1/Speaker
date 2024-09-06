//
//  HomeInit.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

final class HomeInit {
    static func createViewController() -> UIViewController {
        let router = HomeRouter()
        let presenter = HomePresenter(router: router)
        let viewController = HomeViewController(presenter: presenter, router: router)

        router.controller = viewController

        return viewController
    }
}
