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

    private var lastCount = 0

    private var searchArray = [AudioTrack]()

    private var isSearchResultMode = false

    private var choosenIndex = 0
    private var choosenID = UUID()
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

        if !isSearchResultMode {
            checkNeedUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
        AudioManager.shared.libraryDelegate = self
    }
}

// MARK: - Methods

extension LibraryViewController {
    func setPlayPauseRow(index: Int) {
        let rows = mainTable.numberOfRows(inSection: 0)

        guard rows > 0 else {return}
        for row in 0...rows {
            let indexPathCell = IndexPath(row: row, section: 0)
            guard let cell = mainTable.cellForRow(at: indexPathCell) as? LibraryCell else {
                return
            }
            if row != index {
                cell.isPlay(false)
            } else {
                if AudioManager.shared.isPlayNow {
                    cell.isPlay(true)
                } else {
                    cell.isPlay(false)
                }
            }
        }
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

    func checkNeedUpdate() {
        guard AudioManager.shared.allTracks.count != 0 else {
            mainTable.isHidden = true
            mainTable.reloadData()
            emptyView.isHidden = false
            return
        }

        if lastCount != AudioManager.shared.allTracks.count {
            lastCount = AudioManager.shared.allTracks.count
            mainTable.reloadData()
            mainTable.isHidden = false
            emptyView.isHidden = true
        }
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
            $0.bottom.equalTo(view.snp.bottom).inset(isSmallDevice ? 146 : 176)
        })

        mainTable.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.snp.bottom).inset(isSmallDevice ? 146 : 176)
        })
    }
}

// MARK: - UITableViewDelegate

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearchResultMode ? searchArray.count : AudioManager.shared.allTracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LibraryCell.getCell(tableView, for: indexPath)
        if isSearchResultMode {
            cell.configure(searchArray[indexPath.row])
            if searchArray[indexPath.row].id == AudioManager.shared.track?.id && AudioManager.shared.isPlayNow {
                cell.isPlay(true)
            } else {
                cell.isPlay(false)
            }
        } else {
            cell.configure(AudioManager.shared.allTracks[indexPath.row])
            if indexPath.row == AudioManager.shared.currentIndex && AudioManager.shared.isPlayNow {
                cell.isPlay(true)
            } else {
                cell.isPlay(false)
            }
        }

        cell.didTapSettings = {
            self.choosenIndex = indexPath.row
            self.choosenID = self.isSearchResultMode ? self.searchArray[indexPath.row].id : AudioManager.shared.allTracks[indexPath.row].id
            self.showSheetAlert()
        }

        cell.didTapPlayPause = {
            if self.isSearchResultMode {
                if self.searchArray[indexPath.row].id == AudioManager.shared.track?.id {

                    if AudioManager.shared.isPlayNow {
                        AudioManager.shared.pause()
                    } else {
                        AudioManager.shared.play()
                    }
                } else {
                    AudioManager.shared.selectMusicFromLibrary(index: indexPath.row,
                                                               isSearch: true,
                                                               id: self.searchArray[indexPath.row].id)
                }
            } else {
                let selectRow = indexPath.row
                if selectRow == AudioManager.shared.currentIndex {

                    if AudioManager.shared.isPlayNow {
                        AudioManager.shared.pause()
                    } else {
                        AudioManager.shared.play()
                    }
                } else {
                    AudioManager.shared.selectMusicFromLibrary(index: indexPath.row)
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("index from did select - \(indexPath.row)")
    }
}

// MARK: - LibraryProtocol

extension LibraryViewController: LibraryProtocol {
    func needUpdateTable(_ index: Int, id: UUID) {
        if !isSearchResultMode {
            setPlayPauseRow(index: index)
        } else {
            if let searchIndex = searchArray.firstIndex(where: {$0.id == id }) {
                setPlayPauseRow(index: searchIndex)
            }
        }
    }
}


// MARK: - NavBar

private extension LibraryViewController {
    func setNavBar() {
        navigationItem.title = "Library"
        addSearchButton()
        addAddButton()
//        addInfoButton()
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
        searchArray = [AudioTrack]()
        presenter?.selectSearch()
    }

    @objc func tapAdd() {
        presenter?.selectAddInfo()
    }

    @objc func tapInfo() {
        presenter?.selectAddInfo()
    }

    func setBackButton() {
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
        isSearchResultMode = false
        addAddButton()
        searchArray = [AudioTrack]()
        mainTable.reloadData()
    }

    func showSheetAlert() {
        let alert = UIAlertController(title: "",
                                      message: "Delete track?",
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler:{ (UIAlertAction)in
            print("User click Delete button")

            if self.isSearchResultMode {
                self.presenter?.deleteFromSearch(self.choosenID)
                self.searchArray.remove(at: self.choosenIndex)
            } else {
                self.presenter?.selectDelete(self.choosenIndex, id: self.choosenID)
            }

            if AudioManager.shared.allTracks.isEmpty {
                self.emptyView.isHidden = false
                self.mainTable.isHidden = true
            }
            DispatchQueue.main.async {
                self.mainTable.reloadData()
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler:{ (UIAlertAction)in
            print("User click Cancel button")
        }))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
    }
}

// MARK: - SearchDelegate

extension LibraryViewController: SearchDelegate {
    func search(_ query: String) {
        let text = query.lowercased()
        isSearchResultMode = true

        AudioManager.shared.allTracks.forEach({
            if $0.artist?.lowercased().contains(text) ?? false || $0.titleTrack?.lowercased().contains(text) ?? false {
                searchArray.append($0)
            }
        })

        mainTable.reloadData()
        setBackButton()
    }
}

