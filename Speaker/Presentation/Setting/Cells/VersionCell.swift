import UIKit

final class VersionCell: SpeakerTableCell {

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    private lazy var title: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 11)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .textGrayLight
        if let version = appVersion {
            label.text = "App version \(version)"
        }
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override func setup() {
        selectionStyle = UITableViewCell.SelectionStyle.none
        contentView.backgroundColor = .black

        configureConstraints()
    }
}

extension VersionCell {

    private func configureConstraints() {

        contentView.addSubview(title)

        title.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(18)
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
        })
    }
}

