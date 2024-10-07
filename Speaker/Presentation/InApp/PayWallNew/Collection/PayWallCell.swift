import UIKit
import AVFoundation

final class PayWallCell: SpeakerCollectionCell {

    private let duringLabel: UILabel = {
        let label = UILabel()
        let fontSize: CGFloat = phoneSize == .big ? 14 : 10
        label.font = .poppins(.regular, size: fontSize)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(.bold, size: 17)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let ficha1: UILabel = {
        let label = UILabel()
        let fontSize: CGFloat = phoneSize == .big ? 12 : 9
        label.font = .poppins(.regular, size: fontSize)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let ficha2: UILabel = {
        let label = UILabel()
        let fontSize: CGFloat = phoneSize == .big ? 12 : 9
        label.font = .poppins(.regular, size: fontSize)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    //MARK: - Overrides

    override class var size: CGSize {
        let width: CGFloat = 95
        let height: CGFloat = 122
        return CGSize(
            width: width,
            height: height
        )
    }

    override func setup() {
        layer.cornerRadius = 10
        backgroundColor = .totalBlack
    }

    func configure(_ data: PayWallCellModel) {
        duringLabel.text = data.during.uppercased()
        priceLabel.text = data.price
        if data.ficha.count == 1 {
            ficha1.text = data.ficha[0]
        } else {
            let fontSize: CGFloat = phoneSize == .big ? 12 : 9
            let attrs1 = [NSAttributedString.Key.font : UIFont.poppins(.regular, size: fontSize),
                          NSAttributedString.Key.foregroundColor : UIColor.white]
            let attrs2 = [NSAttributedString.Key.font : UIFont.poppins(.regular, size: fontSize),
                          NSAttributedString.Key.foregroundColor : UIColor.white,
                          NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]

            let attributedString1 = NSMutableAttributedString(string: "• ", attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string: "$2,08/month", attributes: attrs2)
            attributedString1.append(attributedString2)
            ficha1.attributedText = attributedString1
        }
        ficha2.text = data.ficha.count == 2 ? data.ficha[1] : ""
        configureConstraints()
    }

    func setSelect(_ isSelect: Bool) {
        if isSelect {
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 2
        } else {
            layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 0
        }
    }
}

extension PayWallCell {

    private func configureConstraints() {

        contentView.addSubview(duringLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(ficha1)
        contentView.addSubview(ficha2)

        duringLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(phoneSize == .big ? 12 : 9)
        })

        priceLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(phoneSize == .big ? 42 : 38)
            $0.leading.equalToSuperview().offset(phoneSize == .big ? 12 : 9)
        })

        ficha1.snp.makeConstraints({
            $0.top.equalTo(priceLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(phoneSize == .big ? 12 : 9)
            $0.trailing.equalToSuperview().inset(4)
        })

        ficha2.snp.makeConstraints({
            $0.top.equalTo(ficha1.snp.bottom)
            $0.leading.equalToSuperview().offset(phoneSize == .big ? 12 : 9)
            $0.trailing.equalToSuperview().inset(4)
        })
    }
}
