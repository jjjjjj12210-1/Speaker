import UIKit

final class BluetoothConnectCell: SpeakerTableCell {

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackGray
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var title: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 14)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .natural
        return label
    }()

    override func setup() {
        selectionStyle = UITableViewCell.SelectionStyle.none
        contentView.backgroundColor = .white

        configureConstraints()
    }

    func configure(icon: UIImage, title: String) {
        self.icon.image = icon
        self.title.text = title
    }
}

extension BluetoothConnectCell {

    private func configureConstraints() {

        contentView.addSubview(backView)
        backView.addSubview(icon)
        backView.addSubview(title)

        backView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(58)
        })

        icon.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(27)
        })

        title.snp.makeConstraints({
            $0.leading.equalTo(icon.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        })
    }
}
