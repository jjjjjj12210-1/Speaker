//
//  BluetoothMenuViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 31.08.2024.
//

import UIKit

protocol BluetoothMenuPresenterOutputInterface: AnyObject {

}

final class BluetoothMenuViewController: UIViewController {

    private var presenter: BluetoothMenuPresenterInterface?
    private var router: BluetoothMenuRouterInterface?

    init(presenter: BluetoothMenuPresenterInterface, router: BluetoothMenuRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: String(describing: BluetoothMenuViewController.self),
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

// MARK: - BluetoothMenuPresenterOutputInterface

extension BluetoothMenuViewController: BluetoothMenuPresenterOutputInterface {

}

// MARK: - UISetup

private extension BluetoothMenuViewController {
    func customInit() {

    }
}
