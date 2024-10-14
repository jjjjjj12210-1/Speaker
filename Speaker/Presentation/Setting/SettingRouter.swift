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
    func showShare()
}

class SettingRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - SettingRouterInterface

extension SettingRouter: SettingRouterInterface {
    func showShare() {
        guard let baseViewController = controller else { return }
        if let link = URL(string: "itms-apps://itunes.apple.com/app/id\(AppData.appID)") {
            let objectsToShare = [link]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            baseViewController.navigationController?.present(activityVC, animated: true)
        }
    }
    
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
