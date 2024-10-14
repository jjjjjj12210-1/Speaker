import UIKit

final class HowConnectController: SpeakerViewController {

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
        label.text = Text.howConnectTitle
        return label
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .white
        label.font = .custom(.regular, size: 14, fontFamily: .lato)
        label.numberOfLines = 0
        label.text = Text.howConnectText
        return label
    }()

    private lazy var wifiButton: SupportButtonView = {
        let button = SupportButtonView()
        button.viewButton.addTarget(self, action: #selector(tapSupport), for: .touchUpInside)
        return button
    }()

    // MARK: - lifecicle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Private
private extension HowConnectController {

    func customInit() {
        view.addSubview(topView)
        view.addSubview(closeButton)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textLabel)
        containerView.addSubview(wifiButton)

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
            $0.height.equalTo(1200)
        })

        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(10)
        })

        textLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
        })

        wifiButton.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(72)
            $0.top.equalTo(textLabel.snp.bottom).offset(40)
        })
    }

    @objc func tapClose() {
        self.dismiss(animated: true)
    }

    @objc func tapSupport() {
        let service = MailService()
        service.controller = self
        service.sendEmailToSupport()
    }
}
