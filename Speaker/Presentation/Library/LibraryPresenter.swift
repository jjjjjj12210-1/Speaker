//
//  LibraryPresenter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol LibraryPresenterInterface {
    func viewDidLoad(withView view: LibraryPresenterOutputInterface)
    func selectAddInfo()
    func selectSearch()
}

final class LibraryPresenter: NSObject {

    private weak var view: LibraryPresenterOutputInterface?
    private var router: LibraryRouterInterface

    init(router: LibraryRouterInterface) {
        self.router = router
    }
}

// MARK: - LibraryPresenterInterface

extension LibraryPresenter: LibraryPresenterInterface {
    func selectSearch() {
        router.showSearch()
    }
    
    func selectAddInfo() {
        router.showAddInfo()
    }
    
    func viewDidLoad(withView view: LibraryPresenterOutputInterface) {
        self.view = view
    }
}
