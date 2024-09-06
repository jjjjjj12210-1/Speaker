//
//  LibraryInit.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

final class LibraryInit {
    static func createViewController() -> UIViewController {
        let router = LibraryRouter()
        let presenter = LibraryPresenter(router: router)
        let viewController = LibraryViewController(presenter: presenter, router: router)

        router.controller = viewController

        return viewController
    }
}
