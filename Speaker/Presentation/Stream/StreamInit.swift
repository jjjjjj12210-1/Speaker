//
//  StreamInit.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

final class StreamInit {
    static func createViewController() -> UIViewController {
        let router = StreamRouter()
        let presenter = StreamPresenter(router: router)
        let viewController = StreamViewController(presenter: presenter, router: router)

        router.controller = viewController

        return viewController
    }
}
