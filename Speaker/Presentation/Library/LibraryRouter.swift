//
//  LibraryRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol LibraryRouterInterface: AnyObject {
    func showAddInfo()
    func showSearch()
}

class LibraryRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - LibraryRouterInterface

extension LibraryRouter: LibraryRouterInterface {
    func showSearch() {
        guard let baseViewController = controller else { return }
        let controller = SearchViewController()
        controller.modalPresentationStyle = .overFullScreen
        controller.delegate = baseViewController as? any SearchDelegate
        baseViewController.navigationController?.present(controller, animated: false)
    }
    
    func showAddInfo() {
        guard let baseViewController = controller else { return }
        let controller = AddMusicViewController()
        baseViewController.navigationController?.pushViewController(controller, animated: false)
    }
}
