//
//  PayWallPresenter.swift
//  Speaker
//
//  Created by Денис Ледовский on 27.08.2024.
//

import UIKit

protocol PayWallPresenterInterface {
    func viewDidLoad(withView view: PayWallPresenterOutputInterface)
}

final class PayWallPresenter: NSObject {

    private weak var view: PayWallPresenterOutputInterface?
    private var router: PayWallRouterInterface

    init(router: PayWallRouterInterface) {
        self.router = router
    }
}

// MARK: - PayWallPresenterInterface

extension PayWallPresenter: PayWallPresenterInterface {
    func viewDidLoad(withView view: PayWallPresenterOutputInterface) {
        self.view = view
    }
}
