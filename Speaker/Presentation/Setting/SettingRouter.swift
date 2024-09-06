//
//  SettingRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol SettingRouterInterface: AnyObject {

}

class SettingRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - SettingRouterInterface

extension SettingRouter: SettingRouterInterface {

}
