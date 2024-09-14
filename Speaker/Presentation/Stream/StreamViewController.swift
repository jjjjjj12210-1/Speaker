import UIKit
import WebKit

protocol StreamPresenterOutputInterface: AnyObject {

}

final class StreamViewController: SpeakerViewController, WKNavigationDelegate {

    private var presenter: StreamPresenterInterface?
    private var router: StreamRouterInterface?

    typealias DataSource = UICollectionViewDiffableDataSource<StreamSection, StreamCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<StreamSection, StreamCellModel>

    private lazy var dataSource = makeDataSource()

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = 18
        collectionView.delegate = self
        StreamCell.register(collectionView)
        return collectionView
    }()

    private var currentWebView: WKWebView?

    // MARK: - Init
    init(presenter: StreamPresenterInterface, router: StreamRouterInterface) {
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

// MARK: - StreamPresenterOutputInterface

extension StreamViewController: StreamPresenterOutputInterface {

}

// MARK: - UISetup

private extension StreamViewController {
    func customInit() {
        applySnapshot()
        setNavBar()
        
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
        })
    }

    func setWebViewView(title: String, url: String) {
        guard let url = URL(string: url) else {return}

        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true

        view.addSubview(webView)
        webView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom).inset(isSmallDevice ? 146 : 176)
        })

        webView.load(URLRequest(url: url))
        currentWebView = webView
        setBackButton()

        collectionView.isHidden = false

        navigationItem.title = title
    }
}

//MARK: - Layout CollectionView

private extension StreamViewController {

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
                let cell = StreamCell.getCell(collectionView, for: indexPath)
                cell.configure(item)
                return cell
            })
        return dataSource
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        let sections = StreamSection.allSections()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - UICollectionViewDelegate

extension StreamViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: setWebViewView(title: "Audiomack", url: "https://audiomack.com/")
        case 1: setWebViewView(title: "Mixcloud", url: "https://www.mixcloud.com/")
        case 2: setWebViewView(title: "Soundcloud", url: "https://soundcloud.com/")
        case 3: setWebViewView(title: "Spotify", url: "https://open.spotify.com/")
        case 4: setWebViewView(title: "Youtube", url: "https://m.youtube.com/?hl=ru")
        case 5: setWebViewView(title: "Amazon", url: "https://music.amazon.com/")
        case 6: setWebViewView(title: "Pandora", url: "https://www.pandora.com/")
        case 7: setWebViewView(title: "SiriusXM", url: "https://www.siriusxm.com/music")
        case 8: setWebViewView(title: "Browser", url: "https://www.google.com")
        default: return
        }
    }
}


// MARK: - NavBar

private extension StreamViewController {
    func setNavBar() {
        navigationItem.title = "Webcast"
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
        self.navigationItem.leftBarButtonItem = nil
        navigationItem.title = "Webcast"
        collectionView.isHidden = false
        currentWebView?.snp.removeConstraints()
        currentWebView?.removeFromSuperview()
        currentWebView = nil
    }
}
