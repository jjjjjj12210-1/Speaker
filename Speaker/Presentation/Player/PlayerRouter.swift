//
//  PlayerRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 05.09.2024.
//

import UIKit

protocol PlayerRouterInterface: AnyObject {

}

class PlayerRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - PlayerRouterInterface

extension PlayerRouter: PlayerRouterInterface {

}
