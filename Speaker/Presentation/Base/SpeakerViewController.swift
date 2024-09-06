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

    lazy var homePlayerView: HomePlayerView = {
        let button = HomePlayerView()
//        button.viewButton.addTarget(self, action: #selector(tapGuide), for: .touchUpInside)
        return button
    }()

    private lazy var playerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(openPlayer), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseBlack
        view.isAccessibilityElement = false
        setViews()
    }

}

extension SpeakerViewController {
    func hidePlayer(_ isHide: Bool) {
        homePlayerView.isHidden = isHide
        playerButton.isHidden = isHide
    }
}

private extension SpeakerViewController {

    @objc func openPlayer() {
        let controller = PlayerInit.createViewController()
        self.navigationController?.present(controller, animated: true)
    }

    func setViews() {
        view.addSubview(homePlayerView)
        view.addSubview(playerButton)

        homePlayerView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(50)
            $0.height.equalTo(120)
        })

        playerButton.snp.makeConstraints({
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(120)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(50)
            $0.height.equalTo(120)
        })
    }

}
