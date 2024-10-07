//
//  PayWallNewPresenter.swift
//  Speaker
//
//  Created by Денис Ледовский on 05.10.2024.
//

import UIKit

protocol PayWallNewPresenterInterface {
    func viewDidLoad(withView view: PayWallNewPresenterOutputInterface)
    func selectPP()
    func selectTerm()
    func selectClose()
}

final class PayWallNewPresenter: NSObject {

    private weak var view: PayWallNewPresenterOutputInterface?
    private var router: PayWallNewRouterInterface

    init(router: PayWallNewRouterInterface) {
        self.router = router
    }
}

// MARK: - PayWallNewPresenterInterface

extension PayWallNewPresenter: PayWallNewPresenterInterface {
    func selectClose() {
        DispatchQueue.main.async {
            self.router.dismiss()
        }
    }
    
    func viewDidLoad(withView view: PayWallNewPresenterOutputInterface) {
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
