//
//  SettingViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol SettingPresenterOutputInterface: AnyObject {

}

final class SettingViewController: SpeakerViewController {

    private var presenter: SettingPresenterInterface?
    private var router: SettingRouterInterface?

    private let appHubManager = AppHubManager.shared

    private let settingArray = [SettingModel(title: "Share the app", icon: .settingsIcon0),
                                SettingModel(title: "Rate this app", icon: .settingsIcon1),
                                SettingModel(title: "Support", icon: .settingsIcon2),
                                SettingModel(title: "Privacy Policy", icon: .settingsIcon3),
                                SettingModel(title: "Terms of use", icon: .settingsIcon4),
                                SettingModel(title: "Recover purchase", icon: .settingsIcon5)]

    // MARK: - UI
    private lazy var mainTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        SettingTopCell.register(tableView)
        NotificationCell.register(tableView)
        SettingCell.register(tableView)
        VersionCell.register(tableView)
        return tableView
    }()

    // MARK: - init
    init(presenter: SettingPresenterInterface, router: SettingRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - lifecicle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar?.hideTabBar(false)
        hidePlayer(true)
        mainTable.reloadData()

        appHubManager.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
    }
}

// MARK: - SettingPresenterOutputInterface

extension SettingViewController: SettingPresenterOutputInterface {

}

// MARK: - UISetup

private extension SettingViewController {
    func customInit() {
        setNavBar()
        view.backgroundColor = .black

        view.addSubview(mainTable)

        mainTable.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: 
            let cell = SettingTopCell.getCell(tableView, for: indexPath)
            if AudioSessionManager.shared.isConnected {
                cell.configure(AudioSessionManager.shared.currentDevice)
            } else {
                cell.configure("No devices")
            }

            return cell
//        case 1:
//            let cell = NotificationCell.getCell(tableView, for: indexPath)
//            cell.didChangeSwitch = { isOn in
//                print(isOn)
//            }
//            return cell
        case 1...6:
            let cell = SettingCell.getCell(tableView, for: indexPath)
            cell.configure(settingArray[indexPath.row - 1])
            return cell
        case 7:
            let cell = VersionCell.getCell(tableView, for: indexPath)
            return cell
        default:
            let cell = SettingCell.getCell(tableView, for: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: presenter?.selectDevice()
        case 1: presenter?.shareApp()
        case 2: presenter?.rateApp()
        case 3: presenter?.selectSupport()
        case 4: presenter?.selectPP()
        case 5: presenter?.selectTerm()
        case 6:
            showSpinner()
            appHubManager.restore()
        default: return
        }
    }
}

// MARK: - NavBar

private extension SettingViewController {
    func setNavBar() {
        let label = UILabel()
        label.text = "Settings"
        label.font = .poppins(.bold, size: 25)
        label.textColor = .white
        
        navigationItem.titleView = label
    }
}

// MARK: - AppHubManagerDelegate

extension SettingViewController: AppHubManagerDelegate {
    func finishLoadPaywall() { }

    func purchasesWasEnded(success: Bool?, messageError: String) {
        hideSpinner()
        guard let success = success else {
            return
        }
        if !success {
            showErrorAlert(title: "Sorry", message: messageError)
        }
    }
}
