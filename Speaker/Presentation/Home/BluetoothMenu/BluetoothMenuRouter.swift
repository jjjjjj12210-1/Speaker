//
//  BluetoothMenuRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 31.08.2024.
//

import UIKit

protocol BluetoothMenuRouterInterface: AnyObject {

}

class BluetoothMenuRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - BluetoothMenuRouterInterface

extension BluetoothMenuRouter: BluetoothMenuRouterInterface {

}
