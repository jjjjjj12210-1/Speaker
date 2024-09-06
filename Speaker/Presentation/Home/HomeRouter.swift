//
//  HomeRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol HomeRouterInterface: AnyObject {

}

class HomeRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - HomeRouterInterface

extension HomeRouter: HomeRouterInterface {

}
