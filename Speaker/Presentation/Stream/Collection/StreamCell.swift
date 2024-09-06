import UIKit

final class StreamCell: SpeakerCollectionCell {

    private let imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.semibold, size: 12)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override func setup() {
        layer.cornerRadius = 20
        backgroundColor = .white.withAlphaComponent(0.1)
        configureConstraints()
    }

    func configure(_ data: StreamCellModel) {
        imageCell.image = data.image
        titleLabel.text = data.title
    }
}

extension StreamCell {

    private func configureConstraints() {

        contentView.addSubview(imageCell)
        contentView.addSubview(titleLabel)

        imageCell.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.centerY)
            $0.size.equalTo(27)
        })

        titleLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(2)
            $0.top.equalTo(imageCell.snp.bottom).offset(6)
        })
    }
}
