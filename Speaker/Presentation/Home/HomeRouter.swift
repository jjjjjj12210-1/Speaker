//
//  HomeRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol HomeRouterInterface: AnyObject {
    func showWiFi()
    func showBluetooth()
    func showVolume()
    func showBass()
    func showTreble()
}

class HomeRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - HomeRouterInterface

extension HomeRouter: HomeRouterInterface {
    func showVolume() {
        guard let baseViewController = controller else { return }
        let controller = SliderViewController(mode: .volume)
        controller.modalPresentationStyle = .overFullScreen
        baseViewController.navigationController?.present(controller, animated: false)
    }
    
    func showBass() {
        guard let baseViewController = controller else { return }
        let controller = SliderViewController(mode: .bass)
        controller.modalPresentationStyle = .overFullScreen
        baseViewController.navigationController?.present(controller, animated: false)
    }
    
    func showTreble() {
        guard let baseViewController = controller else { return }
        let controller = SliderViewController(mode: .treble)
        controller.modalPresentationStyle = .overFullScreen
        baseViewController.navigationController?.present(controller, animated: false)
    }
    
    func showBluetooth() {
        guard let baseViewController = controller else { return }
        let controller = BluetoothMenuInit.createViewController()
        baseViewController.navigationController?.pushViewController(controller, animated: false)
    }
    
    func showWiFi() {
        guard let baseViewController = controller else { return }
        let controller = WiFiConnectViewController()
        controller.modalPresentationStyle = .overFullScreen
        baseViewController.navigationController?.present(controller, animated: false)
    }
}
