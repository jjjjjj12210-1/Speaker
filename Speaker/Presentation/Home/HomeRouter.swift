//
//  HomeRouter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit
//import AVFoundation
import MediaPlayer
//import AVKit

protocol HomeRouterInterface: AnyObject {
    func showWiFi()
    func showBluetooth()
    func showVolume()
    func showBass()
    func showTreble()
    func showHowConnect()
}

class HomeRouter: NSObject {
    weak var controller: UIViewController?
}

// MARK: - HomeRouterInterface

extension HomeRouter: HomeRouterInterface {
    func showHowConnect() {
        guard let baseViewController = controller else { return }
        let vc = HowConnectController()
        let controller = UINavigationController(rootViewController: vc)
        baseViewController.navigationController?.present(controller, animated: true)
    }
    
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
        let controller = WiFiInfoController()
        baseViewController.navigationController?.present(controller, animated: true)
//        let controller = WiFiConnectViewController()
//        controller.modalPresentationStyle = .overFullScreen
//        baseViewController.navigationController?.present(controller, animated: false)
    }
}
