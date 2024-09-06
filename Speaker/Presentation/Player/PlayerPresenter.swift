//
//  PlayerPresenter.swift
//  Speaker
//
//  Created by Денис Ледовский on 05.09.2024.
//

import UIKit

protocol PlayerPresenterInterface {
    func viewDidLoad(withView view: PlayerPresenterOutputInterface)
}

final class PlayerPresenter: NSObject {

    private weak var view: PlayerPresenterOutputInterface?
    private var router: PlayerRouterInterface

    init(router: PlayerRouterInterface) {
        self.router = router
    }
}

// MARK: - PlayerPresenterInterface

extension PlayerPresenter: PlayerPresenterInterface {
    func viewDidLoad(withView view: PlayerPresenterOutputInterface) {
        self.view = view
    }
}
