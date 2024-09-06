//
//  BluetoothMenuRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 31.08.2024.
//

import UIKit

protocol BluetoothMenuRouterInterface: AnyObject {
    func dismiss()
    func showBluetoothConnect(isConnect: Bool)
}

class BluetoothMenuRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - BluetoothMenuRouterInterface

extension BluetoothMenuRouter: BluetoothMenuRouterInterface {
    func showBluetoothConnect(isConnect: Bool) {
        guard let baseViewController = controller else { return }
        let controller = BluetoothConnectViewController(isConnected: isConnect)
        baseViewController.navigationController?.present(controller, animated: true)
    }
    
    func dismiss() {
        guard let baseViewController = controller else { return }
        baseViewController.navigationController?.popViewController(animated: false)
    }
}
