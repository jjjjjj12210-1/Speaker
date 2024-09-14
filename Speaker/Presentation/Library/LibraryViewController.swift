//
//  LibraryViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol LibraryPresenterOutputInterface: AnyObject {

}

final class LibraryViewController: SpeakerViewController {

    private var presenter: LibraryPresenterInterface?
    private var router: LibraryRouterInterface?
    // MARK: - UI
    
    private lazy var emptyView: EmptyLibView = {
        let view = EmptyLibView()
        view.viewButton.addTarget(self, action: #selector(tapEmptyInfo), for: .touchUpInside)
        view.isHidden = true
        return view
    }()

    private lazy var mainTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .baseBlack
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset.top = 20

        LibraryCell.register(tableView)
        return tableView
    }()

    // MARK: - init

    init(presenter: LibraryPresenterInterface, router: LibraryRouterInterface) {
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
        hidePlayer(false)
        tabBar?.hideTabBar(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
    }
}

// MARK: - LibraryPresenterOutputInterface

extension LibraryViewController: LibraryPresenterOutputInterface {

}

//MARK: - Private
private extension LibraryViewController {
    @objc func tapEmptyInfo() {
        presenter?.selectAddInfo()
    }
}


// MARK: - UISetup

private extension LibraryViewController {
    func customInit() {
        setNavBar()

        view.addSubview(emptyView)
        view.addSubview(mainTable)

        emptyView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            $0.bottom.equalTo(homePlayerView.snp.top)
            $0.bottom.equalTo(view.snp.bottom).inset(isSmallDevice ? 146 : 176)
        })

        mainTable.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            $0.bottom.equalTo(homePlayerView.snp.top)
            $0.bottom.equalTo(view.snp.bottom).inset(isSmallDevice ? 146 : 176)
        })
    }
}

// MARK: - UITableViewDelegate

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LibraryCell.getCell(tableView, for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - NavBar

private extension LibraryViewController {
    func setNavBar() {
        navigationItem.title = "Library"
        addSearchButton()
//        addAddButton()
        addInfoButton()
    }

    func addSearchButton() {
        let buttonSize: CGFloat = 19
        let button = SpeakerButton.init(type: .custom)
        button.setImage(.libSearch, for: .normal)
        button.setImage(.libSearch, for: .highlighted)
        button.frame = CGRect.init(x: 0, y: 0, width: buttonSize, height: buttonSize)
        button.addTarget(self, action: #selector(tapSearch), for: .touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }

    func addAddButton() {
        let buttonSize: CGFloat = 25
        let button = SpeakerButton.init(type: .custom)
        button.setImage(.libAdd, for: .normal)
        button.setImage(.libAdd, for: .highlighted)
        button.frame = CGRect.init(x: 0, y: 0, width: buttonSize, height: buttonSize)
        button.addTarget(self, action: #selector(tapAdd), for: .touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }

    func addInfoButton() {
        let buttonSize: CGFloat = 19
        let button = SpeakerButton.init(type: .custom)
        button.setImage(.libInfo, for: .normal)
        button.setImage(.libInfo, for: .highlighted)
        button.frame = CGRect.init(x: 0, y: 0, width: buttonSize, height: buttonSize)
        button.addTarget(self, action: #selector(tapInfo), for: .touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }

    @objc func tapSearch() {
        presenter?.selectSearch()
    }

    @objc func tapAdd() {
        presenter?.selectAddInfo()
    }

    @objc func tapInfo() {
        presenter?.selectAddInfo()
    }
}


