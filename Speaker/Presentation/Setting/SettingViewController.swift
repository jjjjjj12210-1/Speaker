//
//  SettingViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol SettingPresenterOutputInterface: AnyObject {

}

final class SettingViewController: UIViewController {

    private var presenter: SettingPresenterInterface?
    private var router: SettingRouterInterface?

    init(presenter: SettingPresenterInterface, router: SettingRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: String(describing: SettingViewController.self),
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

// MARK: - SettingPresenterOutputInterface

extension SettingViewController: SettingPresenterOutputInterface {

}

// MARK: - UISetup

private extension SettingViewController {
    func customInit() {

    }
}
