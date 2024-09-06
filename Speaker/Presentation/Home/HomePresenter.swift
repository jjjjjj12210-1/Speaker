//
//  HomePresenter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol HomePresenterInterface {
    func viewDidLoad(withView view: HomePresenterOutputInterface)
}

final class HomePresenter: NSObject {

    private weak var view: HomePresenterOutputInterface?
    private var router: HomeRouterInterface

    init(router: HomeRouterInterface) {
        self.router = router
    }
}

// MARK: - HomePresenterInterface

extension HomePresenter: HomePresenterInterface {
    func viewDidLoad(withView view: HomePresenterOutputInterface) {
        self.view = view
    }
}
