import UIKit

final class DeviceConnectedViewController: SpeakerViewController {

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var onStatusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .homeConnect
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var onStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .textGrayLight
        label.font = .poppins(.regular, size: 11)
        label.text = "Connected"
        label.numberOfLines = 1
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.bold, size: 22)
        label.numberOfLines = 2
        label.text = "Your device has been \nsuccessfully connected"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        tap.addTarget(self, action: #selector(tapBack))
        view.addGestureRecognizer(tap)

        view.backgroundColor = .black.withAlphaComponent(0.85)

        view.addSubview(backView)
        backView.addSubview(onStatusImage)
        backView.addSubview(onStatusLabel)
        backView.addSubview(titleLabel)

        backView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(152)
        })

        onStatusLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(34)
            $0.centerX.equalToSuperview()
        })

        onStatusImage.snp.makeConstraints({
            $0.size.equalTo(10)
            $0.centerY.equalTo(onStatusLabel.snp.centerY)
            $0.trailing.equalTo(onStatusLabel.snp.leading).inset(-6)
        })

        titleLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(onStatusLabel.snp.bottom).offset(4)
        })
    }

    @objc private func tapBack() {
        self.dismiss(animated: false)
    }
}
