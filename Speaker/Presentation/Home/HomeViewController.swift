//
//  HomeViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol HomePresenterOutputInterface: AnyObject {

}

final class HomeViewController: SpeakerViewController {

    // MARK: - Property
    private var presenter: HomePresenterInterface?
    private var router: HomeRouterInterface?

    private let disconectText = "Choose the connection type"
    private let connectText = "Connected"

    private let leftRightInset: CGFloat = 22

    private var isConnetceted = false
    // MARK: - UI

    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = isConnetceted ? .homeSoundOn : .homeSoundOff
        return imageView
    }()

    private lazy var onStatusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = isConnetceted ? .homeConnect : .homeDisconect
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var onStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .textGrayLight
        label.font = .poppins(.regular, size: 11)
        label.text = isConnetceted ? connectText : disconectText
        label.numberOfLines = 1
        return label
    }()

    private lazy var bluetoothButton: HomeButtonView = {
        let button = HomeButtonView()
        if isConnetceted {
            button.configure(icon: .homeVolume, title: "Volume")
        } else {
            button.configure(icon: .homeBluetooth, title: "Bluetooth")
        }
        button.viewButton.addTarget(self, action: #selector(tapBluetooth), for: .touchUpInside)
        return button
    }()

    private lazy var wifiButton: HomeButtonView = {
        let button = HomeButtonView()
        if isConnetceted {
            button.configure(icon: .homeBass, title: "Bass")
        } else {
            button.configure(icon: .homeWifi, title: "WiFi")
        }
        button.viewButton.addTarget(self, action: #selector(tapWiFi), for: .touchUpInside)
        return button
    }()

    private lazy var airPlayButton: HomeButtonView = {
        let button = HomeButtonView()
        if isConnetceted {
            button.configure(icon: .homeTreble, title: "Treble")
        } else {
            button.configure(icon: .homeAirplay, title: "AirPlay")
        }
        button.viewButton.addTarget(self, action: #selector(tapAirPlay), for: .touchUpInside)
        return button
    }()

    private lazy var stackButtonsView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [bluetoothButton, wifiButton, airPlayButton])
        stack.axis = .horizontal
        stack.spacing = 15
        stack.distribution = .equalSpacing
        return stack
    }()

    private lazy var connectionGuideButton: HomeConnectionHelpView = {
        let button =  HomeConnectionHelpView()
        if isConnetceted {
            button.configure(isConnetceted, nameDevice: "Kolonka 360")
        } else {
            button.configure(isConnetceted)
        }
        button.viewButton.addTarget(self, action: #selector(tapGuide), for: .touchUpInside)
        return button
    }()


    // MARK: - init
    init(presenter: HomePresenterInterface, router: HomeRouterInterface) {
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

// MARK: - HomePresenterOutputInterface

extension HomeViewController: HomePresenterOutputInterface {

}

// MARK: - Private

private extension HomeViewController {

    @objc func tapBluetooth() {
        if isConnetceted {
            presenter?.selectVolume()
        } else {
            presenter?.selectBluetooth()
        }
    }

    @objc func tapWiFi() {
        if isConnetceted {
            presenter?.selectBass()
        } else {
            presenter?.selectWifi()
        }
    }

    @objc func tapAirPlay() {
        if isConnetceted {
            presenter?.selectTreble()
        } else {

        }
    }

    @objc func tapGuide() {
        isConnetceted = true
        mainImage.image = isConnetceted ? .homeSoundOn : .homeSoundOff
        onStatusImage.image = isConnetceted ? .homeConnect : .homeDisconect
        onStatusLabel.text = isConnetceted ? connectText : disconectText
        bluetoothButton.configure(icon: .homeVolume, title: "Volume")
        wifiButton.configure(icon: .homeBass, title: "Bass")
        airPlayButton.configure(icon: .homeTreble, title: "Treble")
    }
}

// MARK: - UISetup

private extension HomeViewController {
    func customInit() {
        setNavBar()

        view.addSubview(mainImage)
        view.addSubview(onStatusLabel)
        view.addSubview(onStatusImage)
        view.addSubview(bluetoothButton)
        view.addSubview(wifiButton)
        view.addSubview(airPlayButton)
        view.addSubview(stackButtonsView)
        view.addSubview(connectionGuideButton)

        connectionGuideButton.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(leftRightInset)
            $0.bottom.equalTo(homePlayerView.snp.top).offset(-16)
            $0.height.equalTo(72)
        })

        let widthButton = (deviceWidth - (leftRightInset * 2) - 30)/3
        bluetoothButton.snp.makeConstraints({
            $0.width.equalTo(widthButton)
        })
        wifiButton.snp.makeConstraints({
            $0.width.equalTo(widthButton)
        })
        airPlayButton.snp.makeConstraints({
            $0.width.equalTo(widthButton)
        })

        stackButtonsView.snp.makeConstraints({
            $0.bottom.equalTo(connectionGuideButton.snp.top).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(leftRightInset)
            $0.height.equalTo(85)
        })

        onStatusLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(stackButtonsView.snp.top).offset(-16)
        })

        onStatusImage.snp.makeConstraints({
            $0.size.equalTo(10)
            $0.centerY.equalTo(onStatusLabel.snp.centerY)
            $0.trailing.equalTo(onStatusLabel.snp.leading).inset(-6)
        })

        if isSmallDevice {
            mainImage.snp.makeConstraints({
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview().inset(40)
                $0.height.equalTo(250)
            })
        } else {
            let height = deviceWidth - 40
            mainImage.snp.makeConstraints({
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(height)
            })
        }
    }
}

// MARK: - NavBar

private extension HomeViewController {
    func setNavBar() {
        navigationItem.title = "Connect Device"
    }
}
