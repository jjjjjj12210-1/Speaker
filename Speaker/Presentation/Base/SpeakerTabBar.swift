import UIKit

final class SpeakerTabBar: UITabBarController {

    // MARK: - Properties

    var currentController: UIViewController?
    private let audioManager = AudioManager.shared

    // MARK: - UI

    private var buttonsArray = [UIImageView]()

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .tabBarBlack
        view.layer.cornerRadius = isSmallDevice ? 20 : 40
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    lazy var homePlayerView: HomePlayerView = {
        let button = HomePlayerView()
        return button
    }()

    private lazy var playerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(openPlayer), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecicle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarUI()
        addPlayer()
        addCustomTabBarView()
        setButtonsButton()
        audioManager.audioDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func hideTabBar(_ isHidden: Bool) {
        tabBar.isHidden = isHidden
        topView.isHidden = isHidden
    }

    func hidePlayer(_ isHide: Bool) {
        homePlayerView.isHidden = isHide
        playerButton.isHidden = isHide
    }

    func updatePlayStatus() {
        homePlayerView.updatePlay()
        homePlayerView.setTrackInfo()
    }
}

private extension SpeakerTabBar {

    @objc func openPlayer() {
        let controller = PlayerInit.createViewController()
        currentController?.navigationController?.present(controller, animated: true)
    }

    func setupTabBarUI() {
        tabBar.unselectedItemTintColor = .tabBarUnselect
        tabBar.tintColor = .white
        tabBar.backgroundColor = .clear

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            appearance.backgroundEffect = nil
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }

    func setButtonsButton() {
        for index in 0...3 {
            let image = UIImageView()
            image.image = UIImage(named: "tabBar.\(index).off")
            image.backgroundColor = .clear

            tabBar.addSubview(image)

            let imageSize = switch index {
            case 0: 23
            case 1: 21
            case 2: 25
            case 3: 28
            default: 28
            }
            image.snp.makeConstraints({
                $0.size.equalTo(imageSize)
                $0.centerY.equalToSuperview()
            })
            buttonsArray.append(image)
        }
        buttonsArray[0].image = .tabBar0On

        buttonsArray[1].snp.makeConstraints({
            $0.trailing.equalTo(tabBar.snp.centerX).offset(-29)
        })

        buttonsArray[2].snp.makeConstraints({
            $0.leading.equalTo(tabBar.snp.centerX).offset(29)
        })

        buttonsArray[0].snp.makeConstraints({
            $0.trailing.equalTo(buttonsArray[1].snp.leading).offset(-58)
        })

        buttonsArray[3].snp.makeConstraints({
            $0.leading.equalTo(buttonsArray[2].snp.trailing).offset(58)
        })

    }

    func addCustomTabBarView() {
        tabBar.addSubview(topView)

        topView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(isSmallDevice ? 50 : 80)
        })

        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.white.withAlphaComponent(0.4).cgColor
        topView.layer.shadowOpacity = 0.3
        topView.layer.shadowRadius = 10
    }

    func addPlayer() {
        view.addSubview(homePlayerView)
        view.addSubview(playerButton)

        homePlayerView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(50)
            $0.bottom.equalToSuperview().inset(isSmallDevice ? 10 : 40)
            $0.height.equalTo(120)
        })

        playerButton.snp.makeConstraints({
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(120)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(50)
            $0.bottom.equalToSuperview().inset(isSmallDevice ? 10 : 40)
            $0.height.equalTo(120)
        })

        self.view.bringSubviewToFront(self.tabBar)
    }
}

// MARK: - UITabBarControllerDelegate

extension SpeakerTabBar: UITabBarControllerDelegate {

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectedIndex = self.tabBar.items?.firstIndex(of: item)
        for index in 0...3 {
            if index == selectedIndex {
                buttonsArray[index].image = UIImage(named: "tabBar.\(index).on")
            } else {
                buttonsArray[index].image = UIImage(named: "tabBar.\(index).off")
            }
        }
    }
}

// MARK: - AudioProtocol

extension SpeakerTabBar: AudioProtocol {
    func updateTimes(currentTime: Double, remainingTime: Double) {

    }
    
    func setStartTime(fullTime: Double) {

    }
    
    func setNextTrackInfo() {
        homePlayerView.setTrackInfo()
    }
}

