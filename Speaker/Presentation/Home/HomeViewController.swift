import UIKit
import MediaPlayer
import AVKit

protocol HomePresenterOutputInterface: AnyObject {

}

final class HomeViewController: SpeakerViewController {

    // MARK: - Property
    private var presenter: HomePresenterInterface?
    private var router: HomeRouterInterface?

    private let disconectText = "Choose the connection type"
    private let connectText = "Connected"

    private let leftRightInset: CGFloat = 22

    private var isConnected = false {
        didSet {
            setMode()
        }
    }
    // MARK: - UI

    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = isConnected ? .homeSoundOn : .homeSoundOff
        return imageView
    }()

    private lazy var onStatusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = isConnected ? .homeConnect : .homeDisconect
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var onStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .textGrayLight
        label.font = .poppins(.regular, size: 11)
        label.text = isConnected ? connectText : disconectText
        label.numberOfLines = 1
        return label
    }()

    private lazy var bluetoothButton: HomeBigButton = {
        let button = HomeBigButton()
        if isConnected {
            button.configure(icon: .homeVolume, title: "Volume")
        } else {
            button.configure(icon: .homeBluetooth, title: "Bluetooth")
        }
        button.viewButton.addTarget(self, action: #selector(tapBluetooth), for: .touchUpInside)
        return button
    }()

    private lazy var volumeButton: HomeButtonView = {
        let button = HomeButtonView()
            button.configure(icon: .homeVolume, title: "Volume")
        button.viewButton.addTarget(self, action: #selector(tapVolume), for: .touchUpInside)
        return button
    }()

    private lazy var wifiButton: WiFiButtonView = {
        let button = WiFiButtonView()
        button.viewButton.addTarget(self, action: #selector(tapWiFi), for: .touchUpInside)
        return button
    }()

    private lazy var bassButton: HomeButtonView = {
        let button = HomeButtonView()
        button.configure(icon: .homeBass, title: "Bass")
        button.viewButton.addTarget(self, action: #selector(tapBass), for: .touchUpInside)
        return button
    }()

    private lazy var airPlayButton: HomeBigButton = {
        let button = HomeBigButton()
        button.configure(icon: .homeAirplay, title: "AirPlay")
        return button
    }()

    private lazy var trebbleButton: HomeButtonView = {
        let button = HomeButtonView()
        button.configure(icon: .homeTreble, title: "Treble")
        button.viewButton.addTarget(self, action: #selector(tapTrebble), for: .touchUpInside)
        return button
    }()

    private lazy var routePickerView: AVRoutePickerView = {
        let routePickerView = AVRoutePickerView()
        routePickerView.tintColor = .clear
        routePickerView.delegate = self
        routePickerView.activeTintColor = .clear
        return routePickerView
    }()

    private lazy var stackUnConnectView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [bluetoothButton, airPlayButton])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .equalSpacing
        return stack
    }()

    private lazy var stackButtonsView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [volumeButton, bassButton, trebbleButton])
        stack.axis = .horizontal
        stack.spacing = 15
        stack.distribution = .equalSpacing
        stack.isHidden = true
        return stack
    }()

    private lazy var connectionGuideButton: HomeConnectionHelpView = {
        let button =  HomeConnectionHelpView()
        if isConnected {
            button.configure(true,
                             nameDevice: AudioSessionManager.shared.currentDevice)
        } else {
            button.configure(false)
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
        tabBar?.hideTabBar(false)

        if isConnected != AudioSessionManager.shared.isConnected {
            isConnected = AudioSessionManager.shared.isConnected
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
        AudioSessionManager.shared.delgate = self
    }
}

// MARK: - HomePresenterOutputInterface

extension HomeViewController: HomePresenterOutputInterface {

}

// MARK: - Private

private extension HomeViewController {

    @objc func tapBluetooth() {
        presenter?.openBluetoothSettings()
    }

    @objc func tapVolume() {
        presenter?.selectVolume()
    }

    @objc func tapWiFi() {
        presenter?.selectWifi()
    }

    @objc func tapBass() {
        presenter?.selectBass()
    }

    @objc func tapTrebble() {
        presenter?.selectTreble()
    }

    @objc func tapGuide() {
        if isConnected {
            if AudioSessionManager.shared.isAirPlay {
                print("air play do")
            } else {
                presenter?.openBluetoothSettings()
            }
        }
    }
}

// MARK: - UISetup

private extension HomeViewController {
    func customInit() {
        setNavBar()

        view.addSubview(mainImage)
        view.addSubview(onStatusLabel)
        view.addSubview(onStatusImage)
        view.addSubview(volumeButton)
        view.addSubview(bassButton)
        view.addSubview(trebbleButton)
        view.addSubview(bluetoothButton)
        view.addSubview(wifiButton)
        view.addSubview(airPlayButton)
        view.addSubview(stackButtonsView)
        view.addSubview(stackUnConnectView)
        view.addSubview(connectionGuideButton)

        connectionGuideButton.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(leftRightInset)
            $0.height.equalTo(72)
            $0.bottom.equalTo(view.snp.bottom).inset(isSmallDevice ? 60 : 90)
        })

        wifiButton.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(leftRightInset)
            $0.height.equalTo(72)
            $0.bottom.equalTo(connectionGuideButton.snp.top).offset(-10)
        })

        let widthButton = (deviceWidth - (leftRightInset * 2) - 30)/3
        volumeButton.snp.makeConstraints({
            $0.width.equalTo(widthButton)
        })
        bassButton.snp.makeConstraints({
            $0.width.equalTo(widthButton)
        })
        trebbleButton.snp.makeConstraints({
            $0.width.equalTo(widthButton)
        })

        stackButtonsView.snp.makeConstraints({
            $0.bottom.equalTo(connectionGuideButton.snp.top).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(leftRightInset)
            $0.height.equalTo(85)
        })

        let widthBigButton = (deviceWidth - (leftRightInset * 2) - 20)/2

        bluetoothButton.snp.makeConstraints({
            $0.width.equalTo(widthBigButton)
        })

        airPlayButton.snp.makeConstraints({
            $0.width.equalTo(widthBigButton)
        })

        stackUnConnectView.snp.makeConstraints({
            $0.bottom.equalTo(wifiButton.snp.top).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(leftRightInset)
            $0.height.equalTo(85)
        })

        onStatusLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom).inset(isSmallDevice ? 320 : 360)
//            $0.bottom.equalTo(stackButtonsView.snp.top).offset(-16)
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

        self.view.addSubview(routePickerView)
        routePickerView.snp.makeConstraints({
            $0.edges.equalTo(airPlayButton.snp.edges)
        })

        setMode()
    }

    func setMode() {
        mainImage.image = isConnected ? .homeSoundOn : .homeSoundOff
        onStatusImage.image = isConnected ? .homeConnect : .homeDisconect
        onStatusLabel.text = isConnected ? connectText : disconectText
        if isConnected {
            routePickerView.isHidden = true
            stackButtonsView.isHidden = false
            stackUnConnectView.isHidden = true
            wifiButton.isHidden = true
            connectionGuideButton.snp.remakeConstraints({
                $0.leading.trailing.equalToSuperview().inset(leftRightInset)
                $0.height.equalTo(72)
                $0.bottom.equalTo(view.snp.bottom).inset(isSmallDevice ? 146 : 176)
            })
//            bluetoothButton.configure(icon: .homeVolume, title: "Volume")
//            wifiButton.configure(icon: .homeBass, title: "Bass")
//            airPlayButton.configure(icon: .homeTreble, title: "Treble")
            connectionGuideButton.configure(true,
                                 nameDevice: AudioSessionManager.shared.currentDevice)
        } else {
            routePickerView.isHidden = false
            stackButtonsView.isHidden = true
            stackUnConnectView.isHidden = false
            wifiButton.isHidden = false
            connectionGuideButton.snp.remakeConstraints({
                $0.leading.trailing.equalToSuperview().inset(leftRightInset)
                $0.height.equalTo(72)
                $0.bottom.equalTo(view.snp.bottom).inset(isSmallDevice ? 60 : 90)
            })
//            bluetoothButton.configure(icon: .homeBluetooth, title: "Bluetooth")
//            wifiButton.configure(icon: .homeWifi, title: "WiFi")
//            airPlayButton.configure(icon: .homeAirplay, title: "AirPlay")
            connectionGuideButton.configure(false)
        }

        if isConnected && AudioSessionManager.shared.isAirPlay {
            routePickerView.isHidden = false
            routePickerView.snp.remakeConstraints({
                $0.edges.equalTo(connectionGuideButton.snp.edges)
            })
        } else {
            routePickerView.snp.remakeConstraints({
                $0.edges.equalTo(airPlayButton.snp.edges)
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

extension HomeViewController: AVRoutePickerViewDelegate {

    func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        print("end")
    }

    func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        print("start")
    }
}

extension HomeViewController: AudioRouteDelegate {
    func changeRoute(_ isConnected: Bool) {
        self.isConnected = isConnected
    }
}
