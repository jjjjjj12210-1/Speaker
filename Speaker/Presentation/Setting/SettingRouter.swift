//
//  SettingRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol SettingRouterInterface: AnyObject {
    func showBluetoothConnect()
    func showMail()
}

class SettingRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - SettingRouterInterface

extension SettingRouter: SettingRouterInterface {
    func showMail() {
        guard let baseViewController = controller else { return }
        let service = MailService()
        service.controller = baseViewController
        service.sendEmailToSupport()
    }

    func showBluetoothConnect() {
        guard let baseViewController = controller else { return }
        let controller = BluetoothConnectViewController(isConnected: true)
        baseViewController.navigationController?.present(controller, animated: true)
    }
}
