//
//  BluetoothMenuViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 31.08.2024.
//

import UIKit

protocol BluetoothMenuPresenterOutputInterface: AnyObject {

}

final class BluetoothMenuViewController: SpeakerViewController {

    private var presenter: BluetoothMenuPresenterInterface?
    private var router: BluetoothMenuRouterInterface?

    private var deviceArray = [BluetoothListModel(title: "Xiaomi Mi Dual Mode Wireless", isConnect: false),
                               BluetoothListModel(title: "Xiaomi Mi Dual Mode Wireless", isConnect: true)]

    // MARK: - UI
    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = .bcLogo
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.bold, size: 26)
        label.text = "Find your \ndevice"
        label.numberOfLines = 2
        return label
    }()

    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .textGrayLight
        label.font = .poppins(.regular, size: 14)
        label.text = "Make sure your device is \nturned on and close to you."
        label.numberOfLines = 1
        return label
    }()

    private lazy var mainTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .baseBlack
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        BluetoothListCell.register(tableView)
        return tableView
    }()

    // MARK: - Init
    init(presenter: BluetoothMenuPresenterInterface, router: BluetoothMenuRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Lifecicle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidePlayer(true)
        tabBar?.hideTabBar(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
    }
}

// MARK: - BluetoothMenuPresenterOutputInterface

extension BluetoothMenuViewController: BluetoothMenuPresenterOutputInterface {

}

// MARK: - UISetup

private extension BluetoothMenuViewController {
    func customInit() {
        setNavBar()

        view.addSubview(mainImage)
        view.addSubview(titleLabel)
        view.addSubview(descLabel)
        view.addSubview(mainTable)

        mainImage.snp.makeConstraints({
            $0.size.equalTo(164)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
        })

        titleLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainImage.snp.bottom).offset(20)
        })

        descLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(34)
        })

        mainTable.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(descLabel.snp.bottom).offset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        })
    }
}

// MARK: - UITableViewDelegate

extension BluetoothMenuViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        deviceArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BluetoothListCell.getCell(tableView, for: indexPath)
        cell.configure(deviceArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        78
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.selectDevice(isConnect: deviceArray[indexPath.row].isConnect)
    }
}

// MARK: - NavBar

private extension BluetoothMenuViewController {
    func setNavBar() {
        navigationItem.title = "Connect Device"

        let button = SpeakerButton.init(type: .custom)
        let normalAttributedString = NSAttributedString(
            string: "BACK",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.textGrayLight,
                NSAttributedString.Key.font : UIFont.poppins(.regular, size: 12)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.setAttributedTitle(normalAttributedString, for: .highlighted)
        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 20)
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }

    @objc func tapBack() {
        presenter?.selectBack()
    }
}
