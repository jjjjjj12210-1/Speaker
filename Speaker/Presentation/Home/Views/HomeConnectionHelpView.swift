import UIKit

final class HomeConnectionHelpView: UIView {

    //MARK: - Property


    //MARK: - UI

    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.semibold, size: 14)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var bottomLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 11)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .textGrayLight
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    lazy var viewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()

    func configure(_ isConnected: Bool, nameDevice: String = "") {
        icon.image = isConnected ? .homeDiscIcon : .homeConnectionGuide
        titleLabel.text = isConnected ? "Disconnect the device" : "Connection help"
        bottomLabel.text = isConnected ? nameDevice : "Step-to-step instruction"

        if isConnected {
            icon.snp.updateConstraints({
                $0.size.equalTo(51)
            })
        } else {
            icon.snp.updateConstraints({
                $0.size.equalTo(44)
            })
        }
    }

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Private
private extension HomeConnectionHelpView {

}

//MARK: - Constraits
private extension HomeConnectionHelpView {

    private func configureConstraints() {

        backgroundColor = .backGray
        layer.cornerRadius = 16

        addSubview(icon)
        addSubview(titleLabel)
        addSubview(bottomLabel)
        addSubview(viewButton)

        icon.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
            $0.leading.equalToSuperview().offset(16)
        })

        titleLabel.snp.makeConstraints({
            $0.leading.equalTo(icon.snp.trailing).offset(8)
            $0.top.equalToSuperview().offset(16)
        })

        bottomLabel.snp.makeConstraints({
            $0.leading.equalTo(icon.snp.trailing).offset(8)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        })

        viewButton.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}
