//
//  PayWallPresenter.swift
//  Speaker
//
//  Created by Денис Ледовский on 27.08.2024.
//

import UIKit

protocol PayWallPresenterInterface {
    func viewDidLoad(withView view: PayWallPresenterOutputInterface)
    func selectPP()
    func selectTerm()
    func needClose()
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
    func needClose() {
        DispatchQueue.main.async {
            self.router.close()
        }
    }
    
    func viewDidLoad(withView view: PayWallPresenterOutputInterface) {
        self.view = view
    }

    //TODO: - Links
    func selectPP() {
//        guard let url = AppData.policyURL else {
//          return
//        }
//        UIApplication.shared.open(url)
    }

    func selectTerm() {
//        guard let url = AppData.termsURL else {
//          return
//        }
//        UIApplication.shared.open(url)
    }
}
