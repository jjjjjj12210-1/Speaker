import UIKit

final class AddMusicCell: SpeakerCollectionCell {

    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.semibold, size: 12)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let subLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 10)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override func setup() {
        layer.cornerRadius = 20
        backgroundColor = .white.withAlphaComponent(0.1)
        configureConstraints()
    }

    func configure(_ data: AddMusicModel) {
        titleLabel.text = data.title
        subLabel.text = data.subTitle
    }
}

extension AddMusicCell {

    private func configureConstraints() {

        contentView.addSubview(titleLabel)
        contentView.addSubview(subLabel)

        titleLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(2)
            $0.bottom.equalTo(contentView.snp.centerY).offset(-4)
        })

        subLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(2)
            $0.top.equalTo(contentView.snp.centerY)
        })
    }
}
