//
//  PayWallNewInit.swift
//  Speaker
//
//  Created by Денис Ледовский on 05.10.2024.
//

import UIKit

final class PayWallNewInit {
    static func createViewController(isFromStream: Bool) -> PayWallNewViewController {
        let router = PayWallNewRouter()
        let presenter = PayWallNewPresenter(router: router)
        let viewController = PayWallNewViewController(isFromStream: isFromStream,
                                                      presenter: presenter,
                                                      router: router)

        router.controller = viewController

        return viewController
    }
}
