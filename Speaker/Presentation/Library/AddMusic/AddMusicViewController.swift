//
//  AddMusicViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 03.09.2024.
//

import UIKit

final class AddMusicViewController: SpeakerViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<AddMusicSection, AddMusicModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<AddMusicSection, AddMusicModel>

    private lazy var dataSource = makeDataSource()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = 18
        collectionView.delegate = self
        AddMusicCell.register(collectionView)
        return collectionView
    }()

    // MARK: - lifecicle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidePlayer(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
    }
}

// MARK: - Private
private extension AddMusicViewController {

    func customInit() {
        applySnapshot()
        setNavBar()
        
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(300)
        })
    }

    func makeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            return self.makeSection()
        }, configuration: configuration)
    }

    func makeSection() -> NSCollectionLayoutSection {

        let heightItem: CGFloat = 85
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .absolute(heightItem))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(heightItem))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 3)
        group.interItemSpacing = .fixed(22)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 22
        return section
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = AddMusicCell.getCell(collectionView, for: indexPath)
                cell.configure(item)
                return cell
            })
        return dataSource
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        let sections = AddMusicSection.allSections()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - UICollectionViewDelegate

extension AddMusicViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let controller = TextInfoViewController(type: .ipad)
            navigationController?.present(controller, animated: true)
        case 1: print("")
        case 2: print("")
        case 3,4,5:
            let controller = TextInfoViewController(type: .dropBox)
            navigationController?.present(controller, animated: true)
        default: return
        }
    }
}

// MARK: - NavBar

private extension AddMusicViewController {
    func setNavBar() {
        navigationItem.title = "Add music"

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
        navigationController?.popViewController(animated: false)
    }
}
