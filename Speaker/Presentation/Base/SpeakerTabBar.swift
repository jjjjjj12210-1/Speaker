import UIKit

final class SpeakerTabBar: UITabBarController {

    // MARK: - Properties


    // MARK: - UI

    private var customTabBarView = CustomTabBar(frame: .zero)

    private var buttonsArray = [UIImageView]()

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .tabBarBlack
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - Lifecicle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarUI()
        addCustomTabBarView()
        setButtonsButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func hideTabBar(_ isHidden: Bool) {
        tabBar.isHidden = isHidden
        customTabBarView.isHidden = isHidden
    }
}

private extension SpeakerTabBar {

    func setupTabBarUI() {
        tabBar.unselectedItemTintColor = .tabBarUnselect
        tabBar.tintColor = .white
        tabBar.backgroundColor = .clear

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance

            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
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
            $0.height.equalTo(80)
        })

        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.white.withAlphaComponent(0.4).cgColor
        topView.layer.shadowOpacity = 0.3
        topView.layer.shadowRadius = 10
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
