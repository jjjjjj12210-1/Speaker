//
//  LibraryRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol LibraryRouterInterface: AnyObject {

}

class LibraryRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - LibraryRouterInterface

extension LibraryRouter: LibraryRouterInterface {

}
