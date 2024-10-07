//
//  PayWallNewViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 05.10.2024.
//

import UIKit

protocol PayWallCloseDelegate: AnyObject {
    func closed()
}

protocol PayWallNewPresenterOutputInterface: AnyObject {

}

final class PayWallNewViewController: SpeakerViewController {

    enum PayVariant {
        case year
        case mounth
        case week
    }

    private var presenter: PayWallNewPresenterInterface?
    private var router: PayWallNewRouterInterface?

    weak var delegate: PayWallCloseDelegate?

    typealias DataSource = UICollectionViewDiffableDataSource<PayWallSection, PayWallCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PayWallSection, PayWallCellModel>

    private lazy var dataSource = makeDataSource()

    private let heightButton: CGFloat = isSmallDevice ? 56 : 78
    private let bottomButtonHeight: CGFloat = 20

    private let isFromStream: Bool
    private let appHubManager = AppHubManager.shared

    private var currentPlan: PayVariant = .year

    private var priceArray: [String] = []

    // MARK: - UI

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setImage(UIImage(systemName: "xmark"), for: .highlighted)
        button.tintColor = .white
        button.alpha = 0.8
        button.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        return button
    }()

    private let topImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .pwnTop
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private let unlimLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .descGray
        label.font = .poppins(.regular, size: 13)
        label.text = "Get unlimited access to all  features"
        label.numberOfLines = 1
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.bold, size: isSmallDevice ? 22 : 26)
        label.text = "Unlimited listening all \nstreaming services"
        label.numberOfLines = 2
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        PayWallCell.register(collectionView)
        return collectionView
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .totalBlack
        button.layer.cornerRadius = heightButton/2
        let normalAttributedString = NSAttributedString(
            string: "Continue",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font : UIFont.poppins(.bold, size: 20)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(tapContinue), for: .touchUpInside)

        button.layer.cornerRadius = heightButton/2
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowRadius = 40.0
        button.layer.shadowOffset = CGSize.zero

        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        return button
    }()

    private lazy var ppButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let normalAttributedString = NSAttributedString(
            string: "Privacy",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.descGray,
                NSAttributedString.Key.font : UIFont.poppins(.regular, size: 10)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(tapPP), for: .touchUpInside)
        return button
    }()

    private lazy var restoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let normalAttributedString = NSAttributedString(
            string: "Restore",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.descGray,
                NSAttributedString.Key.font : UIFont.poppins(.regular, size: 10)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(tapRestore), for: .touchUpInside)
        return button
    }()

    private lazy var termButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let normalAttributedString = NSAttributedString(
            string: "Terms of use",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.descGray,
                NSAttributedString.Key.font : UIFont.poppins(.regular, size: 10)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(tapTerm), for: .touchUpInside)
        return button
    }()


    init(isFromStream: Bool, presenter: PayWallNewPresenterInterface, router: PayWallNewRouterInterface) {
        self.isFromStream = isFromStream
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let loader: PayWallLoaderView = {
        let view = PayWallLoaderView()
        view.isHidden = true
        return view
    }()


    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
        hidePlayer(true)

        appHubManager.delegate = self
    }
}

// MARK: - PayWallNewPresenterOutputInterface

extension PayWallNewViewController: PayWallNewPresenterOutputInterface {

}

// MARK: - Private
private extension PayWallNewViewController {

    @objc func tapContinue() {
        switch currentPlan {
        case .year:
            guard let appHubModel = appHubManager.yearSubscription() else { return }
            showSpinner()
            appHubManager.startPurchase(appHubModel)
        case .mounth:
            guard let appHubModel = appHubManager.mouthSubscription() else { return }
            showSpinner()
            appHubManager.startPurchase(appHubModel)
        case .week:
            guard let appHubModel = appHubManager.weekSubscription() else { return }
            showSpinner()
            appHubManager.startPurchase(appHubModel)
        }
    }

    @objc func tapPP() {
        presenter?.selectPP()
    }

    @objc func tapRestore() {
        showSpinner()
        appHubManager.restore()
    }

    @objc func tapTerm() {
        presenter?.selectTerm()
    }

    @objc func tapClose() {
        if isFromStream {
            delegate?.closed()
            presenter?.selectClose()
        } else {
            presenter?.selectClose()
        }
    }

    func setLoader() {
        collectionView.isHidden = true
        continueButton.isHidden = true

        loader.isHidden = false
        loader.showSpinner()
    }

    func removeLoader() {
        collectionView.isHidden = false
        continueButton.isHidden = false

        loader.isHidden = true
        
        loader.hideSpinner()
    }
}

//MARK: - Layout CollectionView

private extension PayWallNewViewController {

    func makeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            return self.makeSection()
        }, configuration: configuration)
    }

    func makeSection() -> NSCollectionLayoutSection {

        let widhtItem = phoneSize == .big ? 120 : PayWallCell.size.width
        let heigthItem = phoneSize == .big ? 160 : PayWallCell.size.height
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(widhtItem),
                                              heightDimension: .absolute(heigthItem))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(heigthItem))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 3)
        let inset = (deviceWidth - 50 - (widhtItem * 3))/2
        group.interItemSpacing = .fixed(inset)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
        section.interGroupSpacing = 22
        return section
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = PayWallCell.getCell(collectionView, for: indexPath)
                cell.configure(item)
                if indexPath.row == 0 {
                    cell.setSelect(true)
                } else {
                    cell.setSelect(false)
                }
                return cell
            })
        return dataSource
    }

    func applySnapshot(_ prices: [String]) {
        var snapshot = Snapshot()
        let sections = PayWallSection.allSections(prices)
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - UICollectionViewDelegate

extension PayWallNewViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: currentPlan = .year
        case 1: currentPlan = .week
        case 2: currentPlan = .mounth
        default: return
        }

        let rows = collectionView.numberOfItems(inSection: indexPath.section)
        let selectRow = indexPath.row
        guard rows > 0 else {return}
        for row in 0...rows {
            let indexPathCell = IndexPath(row: row, section: indexPath.section)
            guard let cell = collectionView.cellForItem(at: indexPathCell) as? PayWallCell else {
                return
            }
            row == selectRow ? cell.setSelect(true) : cell.setSelect(false)
        }
    }
}

// MARK: - UISetup

private extension PayWallNewViewController {
    func customInit() {
        if appHubManager.subscriptions.count == 3 {
            var prices = [String]()
            prices.append(appHubManager.getPrice(.year))
            prices.append(appHubManager.getPrice(.week))
            prices.append(appHubManager.getPrice(.mounth))
            applySnapshot(prices)
        } else {
            setLoader()
            appHubManager.getDefaultInfo()
        }

        view.backgroundColor = .baseBlack

        view.addSubview(closeButton)
        view.addSubview(topImage)
        view.addSubview(unlimLabel)
        view.addSubview(titleLabel)
        view.addSubview(continueButton)
        view.addSubview(collectionView)
        view.addSubview(ppButton)
        view.addSubview(restoreButton)
        view.addSubview(termButton)
        view.addSubview(loader)

        closeButton.snp.makeConstraints({
            $0.size.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.trailing.equalToSuperview().inset(10)
        })

        let height = deviceWidth * 0.8556
        topImage.snp.updateConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.height.equalTo(height)
        })

        continueButton.snp.makeConstraints({
            $0.height.equalTo(heightButton)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(isSmallDevice ? 46 : 84)
        })

        let bottomButtonWidth = (deviceWidth - 100)/3
        ppButton.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(bottomButtonHeight)
            $0.width.equalTo(bottomButtonWidth - 10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(isSmallDevice ? -16 : -10)
        })

        termButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.height.equalTo(bottomButtonHeight)
            $0.width.equalTo(bottomButtonWidth + 10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(isSmallDevice ? -16 : -10)
        })

        restoreButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(bottomButtonHeight)
            $0.width.equalTo(bottomButtonWidth - 10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(isSmallDevice ? -16 : -10)
        })

        loader.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(continueButton.snp.top).inset(isSmallDevice ? -10 : -26)
            $0.height.equalTo(phoneSize == .big ? 164 : 126)
        })

        collectionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(continueButton.snp.top).inset(isSmallDevice ? -10 : -26)
            $0.height.equalTo(phoneSize == .big ? 164 : 126)
        })

        titleLabel.snp.updateConstraints({
            $0.bottom.equalTo(collectionView.snp.top).inset(isSmallDevice ? -16 : -36)
            $0.centerX.equalToSuperview()
        })

        unlimLabel.snp.updateConstraints({
            $0.bottom.equalTo(titleLabel.snp.top).inset(isSmallDevice ? -6 : -12)
            $0.centerX.equalToSuperview()
        })
    }
}

// MARK: - AppHubManagerDelegate

extension PayWallNewViewController: AppHubManagerDelegate {
    func finishLoadPaywall() {
        DispatchQueue.main.async {
            self.removeLoader()
        }
    }
    
    func purchasesWasEnded(success: Bool?, messageError: String) {
        hideSpinner()
        guard let success = success else {
            return
        }
        success ? presenter?.selectClose() : showErrorAlert(title: "Sorry", message: messageError)
    }
}
