import UIKit

final class WiFiInfoController: SpeakerViewController {

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .topLineGray
        view.layer.cornerRadius = 2
        return view
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        button.setImage(.bcClose, for: .normal)
        button.setImage(.bcClose, for: .highlighted)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .custom(.semibold, size: 18, fontFamily: .lato)
        label.numberOfLines = 2
        label.text = Text.wifiTitle
        return label
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .white
        label.font = .custom(.regular, size: 14, fontFamily: .lato)
        label.numberOfLines = 0
        label.text = Text.wifiText
        return label
    }()

    private lazy var titleLabel2: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .custom(.semibold, size: 18, fontFamily: .lato)
        label.numberOfLines = 2
        label.text = Text.wifiTitle2
        return label
    }()

    private lazy var textLabel2: UILabel = {
        let label = UILabel()

        let attrs1 = [NSAttributedString.Key.font : UIFont.custom(.regular, size: 14, fontFamily: .lato),
                      NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedString.Key.font : UIFont.custom(.bold, size: 14, fontFamily: .lato),
                      NSAttributedString.Key.foregroundColor : UIColor.white]

        let attString1 = NSMutableAttributedString(string:"\n\nConnecting to Wi-Fi", attributes: attrs2)
        let attString2 = NSMutableAttributedString(string:"\n1. **Power On Your Speaker**: Plug in your Sonos speaker and wait for the indicator light to show it's ready (usually blinking green).\n2. **Connect Your Device to Wi-Fi**: Ensure that the smartphone or tablet you're using is connected to the same Wi-Fi network you want to use with your Sonos speaker.\n3. **Open the Sonos App**: Launch the app and follow any prompts that appear.", attributes: attrs1)
        let attString3 = NSMutableAttributedString(string:"\n\nIf Setting Up for the First Time", attributes: attrs2)
        let attString4 = NSMutableAttributedString(string:"\n1. **Select 'Set Up New System'**: If prompted, choose this option.\n2. **Add Your Speaker**: The app will search for nearby Sonos devices. Select your speaker from the list.\n3. **Join Button**: On your speaker, press the join button (often marked with an infinity symbol or a play/pause button) when prompted by the app.\n4. **Enter Wi-Fi Password**: Input your Wi-Fi network password when requested.\n5. **Confirmation**: Wait for the app to confirm that your speaker is connected.", attributes: attrs1)
        let attString5 = NSMutableAttributedString(string:"\n\n### If Reconnecting After a Network Change", attributes: attrs2)
        let attString6 = NSMutableAttributedString(string:"\n1. **Connect via Ethernet (if needed)**: If you're having trouble, connect one of your Sonos devices directly to your router using an Ethernet cable.\n2. **Update Network Settings**:\n- In the Sonos app, go to **Settings > System > Network > Update Networks**.\n- Follow the prompts to enter your new Wi-Fi details.\n3. **Disconnect Ethernet Cable**: Once connected, you can disconnect the Ethernet cable.", attributes: attrs1)

        attString1.append(attString2)
        attString1.append(attString3)
        attString1.append(attString4)
        attString1.append(attString5)
        attString1.append(attString6)
        label.attributedText = attString1
        label.textAlignment = .natural
        label.numberOfLines = 0
        return label
    }()

    // MARK: - lifecicle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
    }
}

// MARK: - Private
private extension WiFiInfoController {

    func customInit() {
        view.addSubview(topView)
        view.addSubview(closeButton)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textLabel)
        containerView.addSubview(titleLabel2)
        containerView.addSubview(textLabel2)

        topView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4)
            $0.top.equalToSuperview().offset(6)
            $0.width.equalTo(60)
        })

        closeButton.snp.makeConstraints({
            $0.size.equalTo(37)
            $0.trailing.equalToSuperview().inset(14)
            $0.top.equalToSuperview().offset(21)
        })

        scrollView.snp.makeConstraints({
            $0.top.equalTo(closeButton.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        })

        containerView.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(1400)
        })

        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(10)
        })

        textLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
        })

        titleLabel2.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(textLabel.snp.bottom).offset(40)
        })

        textLabel2.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(titleLabel2.snp.bottom)
        })
    }

    @objc func tapClose() {
        self.dismiss(animated: true)
    }
}
