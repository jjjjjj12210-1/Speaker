import UIKit

struct BluetoothListModel {
    let title: String
    var isConnect: Bool
}

final class BluetoothListCell: SpeakerTableCell {

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .backGray
        view.layer.cornerRadius = 16
        return view
    }()

    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.backgroundColor = .clear
        imageView.image = .bcSoundLogo
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var title: UILabel = {
       let label = UILabel()
        label.font = .poppins(.semibold, size: 14)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var statusLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 11)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .textGrayLight
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
        contentView.backgroundColor = .baseBlack

        configureConstraints()
    }

    func configure(_ data: BluetoothListModel) {
        title.text = data.title
        statusLabel.text = data.isConnect ? "CONNECTED" : "NOT CONNECTED"
    }
}

extension BluetoothListCell {

    private func configureConstraints() {

        contentView.addSubview(backView)
        backView.addSubview(icon)
        backView.addSubview(title)
        backView.addSubview(statusLabel)
        backView.addSubview(arrowImage)

        backView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(72)
        })

        icon.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
            $0.leading.equalToSuperview().offset(16)
        })

        title.snp.makeConstraints({
            $0.leading.equalTo(icon.snp.trailing).offset(8)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(30)
        })

        statusLabel.snp.makeConstraints({
            $0.leading.equalTo(icon.snp.trailing).offset(8)
            $0.top.equalTo(title.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(30)
        })

        arrowImage.snp.makeConstraints({
            $0.height.equalTo(14)
            $0.width.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        })
    }
}
