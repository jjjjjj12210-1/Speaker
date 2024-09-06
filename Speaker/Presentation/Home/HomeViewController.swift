//
//  HomeViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol HomePresenterOutputInterface: AnyObject {

}

final class HomeViewController: UIViewController {

    private var presenter: HomePresenterInterface?
    private var router: HomeRouterInterface?

    init(presenter: HomePresenterInterface, router: HomeRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: String(describing: HomeViewController.self),
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

// MARK: - HomePresenterOutputInterface

extension HomeViewController: HomePresenterOutputInterface {

}

// MARK: - UISetup

private extension HomeViewController {
    func customInit() {

    }
}
