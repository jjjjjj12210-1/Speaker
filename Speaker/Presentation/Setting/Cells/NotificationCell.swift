import UIKit

final class NotificationCell: SpeakerTableCell {

    var didChangeSwitch: ((Bool)->())?

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.12)
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.backgroundColor = .clear
        imageView.image = .settingsNotification
        return imageView
    }()

    private lazy var title: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 14)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .white
        label.text = "Notifications"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var swicthView: UISwitch = {
        let switchView = UISwitch()
        return switchView
    }()

    private lazy var bottomLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 11)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .textGrayLight
        label.text = "Please, go to Settings and provide permission"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override func setup() {
        selectionStyle = UITableViewCell.SelectionStyle.none
        contentView.backgroundColor = .black

        configureConstraints()
    }

    func configure(_ isOn: Bool) {
        swicthView.setOn(isOn, animated: false)
    }
}

extension NotificationCell {

    private func configureConstraints() {

        contentView.addSubview(backView)
        backView.addSubview(icon)
        backView.addSubview(title)
        backView.addSubview(swicthView)
        contentView.addSubview(bottomLabel)

        backView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(58)
            $0.bottom.equalToSuperview().inset(36)
        })

        icon.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.size.equalTo(30)
            $0.leading.equalToSuperview().offset(16)
        })

        title.snp.makeConstraints({
            $0.leading.equalTo(icon.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        })

        swicthView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        })

        bottomLabel.snp.makeConstraints({
            $0.leading.equalTo(icon.snp.leading)
            $0.top.equalTo(backView.snp.bottom).offset(4)
        })
    }

    func setIsOn(_ isOn: Bool) {
        didChangeSwitch?(isOn)
    }
}

