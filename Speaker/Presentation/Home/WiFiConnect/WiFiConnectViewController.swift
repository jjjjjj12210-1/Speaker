//
//  WiFiConnectViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 31.08.2024.
//

import UIKit

final class WiFiConnectViewController: SpeakerViewController {

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 20
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.bold, size: 22)
        label.numberOfLines = 3
        label.text = "Before setting up, you need \nto connect the device \nvia Bluetooth"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hidePlayer(true)

        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        tap.addTarget(self, action: #selector(tapBack))
        view.addGestureRecognizer(tap)

        view.backgroundColor = .black.withAlphaComponent(0.85)

        view.addSubview(backView)
        backView.addSubview(titleLabel)

        backView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(152)
        })

        titleLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }

    @objc private func tapBack() {
        self.dismiss(animated: false)
    }
}
