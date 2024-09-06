//
//  StreamPresenter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol StreamPresenterInterface {
    func viewDidLoad(withView view: StreamPresenterOutputInterface)
}

final class StreamPresenter: NSObject {

    private weak var view: StreamPresenterOutputInterface?
    private var router: StreamRouterInterface

    init(router: StreamRouterInterface) {
        self.router = router
    }
}

// MARK: - StreamPresenterInterface

extension StreamPresenter: StreamPresenterInterface {
    func viewDidLoad(withView view: StreamPresenterOutputInterface) {
        self.view = view
    }
}
