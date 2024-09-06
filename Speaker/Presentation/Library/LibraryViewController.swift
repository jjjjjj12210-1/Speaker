//
//  LibraryViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol LibraryPresenterOutputInterface: AnyObject {

}

final class LibraryViewController: UIViewController {

    private var presenter: LibraryPresenterInterface?
    private var router: LibraryRouterInterface?

    init(presenter: LibraryPresenterInterface, router: LibraryRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: String(describing: LibraryViewController.self),
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

// MARK: - LibraryPresenterOutputInterface

extension LibraryViewController: LibraryPresenterOutputInterface {

}

// MARK: - UISetup

private extension LibraryViewController {
    func customInit() {

    }
}
