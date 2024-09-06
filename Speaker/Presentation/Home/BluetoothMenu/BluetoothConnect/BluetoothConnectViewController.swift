//
//  BluetoothConnectViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 31.08.2024.
//

import UIKit

final class BluetoothConnectViewController: SpeakerViewController {

    private var isConnected: Bool

    // MARK: - UI

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .topLineGray
        view.layer.cornerRadius = 2
        return view
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        button.setImage(.bcClose, for: .normal)
        button.setImage(.bcClose, for: .highlighted)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.semibold, size: 14)
        label.text = "Difeisi Wi-fi Smart Bulb"
        label.numberOfLines = 2
        return label
    }()

    private lazy var mainTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .baseBlack
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        BluetoothConnectCell.register(tableView)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        hidePlayer(true)
    }

    // MARK: - Init
    init(isConnected: Bool) {
        self.isConnected = isConnected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate

extension BluetoothConnectViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BluetoothConnectCell.getCell(tableView, for: indexPath)
        switch indexPath.row {
        case 0: cell.configure(icon: .bcBluetoth,
                               title: isConnected ? "Connect device" : "Connect device")
        case 1: cell.configure(icon: .bcFoget, title: "Forget device")
        default: print("")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - Private
private extension BluetoothConnectViewController {

    func customInit() {

        view.addSubview(topView)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(mainTable)

        topView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4)
            $0.top.equalToSuperview().offset(6)
            $0.width.equalTo(60)
        })

        closeButton.snp.makeConstraints({
            $0.size.equalTo(37)
            $0.trailing.equalToSuperview().inset(14)
            $0.top.equalToSuperview().offset(21)
        })

        titleLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(closeButton.snp.bottom).offset(12)
        })

        mainTable.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.height.equalTo(150)
        })
    }

    @objc func tapClose() {
        self.dismiss(animated: true)
    }
}
