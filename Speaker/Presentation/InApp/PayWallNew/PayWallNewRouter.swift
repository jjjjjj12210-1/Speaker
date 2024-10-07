//
//  PayWallNewRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 05.10.2024.
//

import UIKit

protocol PayWallNewRouterInterface: AnyObject {
    func dismiss()
}

class PayWallNewRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - PayWallNewRouterInterface

extension PayWallNewRouter: PayWallNewRouterInterface {
    func dismiss() {
        guard let baseViewController = controller else { return }
        baseViewController.dismiss(animated: true)
    }
}
