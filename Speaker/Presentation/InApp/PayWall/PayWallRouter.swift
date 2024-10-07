//
//  PayWallRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 27.08.2024.
//

import UIKit

protocol PayWallRouterInterface: AnyObject {
    func close()
}

class PayWallRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - PayWallRouterInterface

extension PayWallRouter: PayWallRouterInterface {
    func close() {
        let appCoordinator = AppCoordinator()
        appCoordinator.showMain()
    }
}
