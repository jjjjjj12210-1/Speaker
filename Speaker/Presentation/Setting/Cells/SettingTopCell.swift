import UIKit

final class SettingTopCell: SpeakerTableCell {

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
        imageView.image = .settingsTopIcon
        return imageView
    }()

    private lazy var title: UILabel = {
       let label = UILabel()
        label.font = .poppins(.semibold, size: 14)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .white
        label.text = "Linked device"
//        label.text = "No devices"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var deviceLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 11)
        label.numberOfLines = 2
        label.textAlignment = .right
        label.textColor = .white
        label.text = "Station mini"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = .bcArrow
        return imageView
    }()

    override func setup() {
        selectionStyle = UITableViewCell.SelectionStyle.none
        contentView.backgroundColor = .black

        configureConstraints()
    }

//    func configure(_ data: BluetoothListModel) {
//        title.text = data.title
//        statusLabel.text = data.isConnect ? "CONNECTED" : "NOT CONNECTED"
//    }
}

extension SettingTopCell {

    private func configureConstraints() {

        contentView.addSubview(backView)
        backView.addSubview(icon)
        backView.addSubview(title)
        backView.addSubview(deviceLabel)
        backView.addSubview(arrowImage)

        backView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(78)
            $0.bottom.equalToSuperview().inset(16)
        })

        icon.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
            $0.leading.equalToSuperview().offset(16)
        })

        title.snp.makeConstraints({
            $0.leading.equalTo(icon.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        })

        deviceLabel.snp.makeConstraints({
            $0.leading.equalTo(title.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(38)
        })

        arrowImage.snp.makeConstraints({
            $0.height.equalTo(14)
            $0.width.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
        })
    }
}


