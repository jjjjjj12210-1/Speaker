//
//  SpeakerViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 29.08.2024.
//

import UIKit

class SpeakerViewController: UIViewController {

    var tabBar: SpeakerTabBar? {
        return self.tabBarController as? SpeakerTabBar
    }
    
    private var activityView: UIView?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar?.currentController = self
        tabBar?.updatePlayStatus()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseBlack
        view.isAccessibilityElement = false
    }

}

extension SpeakerViewController {
    func hidePlayer(_ isHide: Bool) {
        tabBar?.hidePlayer(isHide)
    }

    func showSpinner() {
        activityView = UIView(frame: self.view.bounds)
        activityView?.backgroundColor = .black.withAlphaComponent(0.2)

        guard let activityView = activityView else {return}
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = activityView.center
        activityIndicator.startAnimating()
        activityView.addSubview(activityIndicator)
        self.view.addSubview(activityView)
    }

    func hideSpinner() {
        DispatchQueue.main.async {
            self.activityView?.removeFromSuperview()
            self.activityView = nil
        }
    }

    func showErrorAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
