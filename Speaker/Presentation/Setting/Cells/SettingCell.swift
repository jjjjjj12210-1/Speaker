import UIKit

struct SettingModel {
    let title: String
    let icon: UIImage
}

final class SettingCell: SpeakerTableCell {

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
        return imageView
    }()

    private lazy var title: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 14)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override func setup() {
        selectionStyle = UITableViewCell.SelectionStyle.none
        contentView.backgroundColor = .black

        configureConstraints()
    }

    func configure(_ data: SettingModel) {
        self.title.text = data.title
        self.icon.image = data.icon
    }
}

extension SettingCell {

    private func configureConstraints() {

        contentView.addSubview(backView)
        backView.addSubview(icon)
        backView.addSubview(title)

        backView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(58)
            $0.bottom.equalToSuperview().inset(6)
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
    }
}
