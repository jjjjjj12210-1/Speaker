//
//  PlayerViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 05.09.2024.
//

import UIKit

protocol PlayerPresenterOutputInterface: AnyObject {

}

final class PlayerViewController: UIViewController {

    private var presenter: PlayerPresenterInterface?
    private var router: PlayerRouterInterface?

    init(presenter: PlayerPresenterInterface, router: PlayerRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: String(describing: PlayerViewController.self),
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

// MARK: - PlayerPresenterOutputInterface

extension PlayerViewController: PlayerPresenterOutputInterface {

}

// MARK: - UISetup

private extension PlayerViewController {
    func customInit() {

    }
}
