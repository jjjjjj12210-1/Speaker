//
//  StreamViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol StreamPresenterOutputInterface: AnyObject {

}

final class StreamViewController: UIViewController {

    private var presenter: StreamPresenterInterface?
    private var router: StreamRouterInterface?

    init(presenter: StreamPresenterInterface, router: StreamRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: String(describing: StreamViewController.self),
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

// MARK: - StreamPresenterOutputInterface

extension StreamViewController: StreamPresenterOutputInterface {

}

// MARK: - UISetup

private extension StreamViewController {
    func customInit() {

    }
}
