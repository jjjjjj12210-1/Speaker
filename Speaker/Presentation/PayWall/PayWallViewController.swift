//
//  PayWallViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 27.08.2024.
//

import UIKit

protocol PayWallPresenterOutputInterface: AnyObject {

}

final class PayWallViewController: UIViewController {

    private var presenter: PayWallPresenterInterface?
    private var router: PayWallRouterInterface?

    init(presenter: PayWallPresenterInterface, router: PayWallRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: String(describing: PayWallViewController.self),
                   bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
    }
}

// MARK: - PayWallPresenterOutputInterface

extension PayWallViewController: PayWallPresenterOutputInterface {

}

// MARK: - UISetup

private extension PayWallViewController {
    func customInit() {

    }
}
