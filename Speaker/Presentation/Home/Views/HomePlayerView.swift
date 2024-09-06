import UIKit

final class HomePlayerView: UIView {

    //MARK: - Property


    //MARK: - UI

    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.image = .songImg
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.semibold, size: 14)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .white
        label.text = "Different world ..."
        return label
    }()

    private lazy var bottomLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 11)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .textGrayLight
        label.text = "Alan Walker, K-391 & Sofia"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(.homePause, for: .normal)
        button.setImage(.homePause, for: .highlighted)

        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.buttonGold.withAlphaComponent(0.5).cgColor
        button.layer.shadowRadius = 16.0
        button.layer.shadowOffset = CGSize.zero

        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        return button
    }()

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
private extension HomePlayerView {

}

//MARK: - Constraits
private extension HomePlayerView {

    private func configureConstraints() {

        backgroundColor = .backGray
        layer.cornerRadius = 50
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        addSubview(icon)
        addSubview(titleLabel)
        addSubview(bottomLabel)
        addSubview(playPauseButton)

        icon.snp.makeConstraints({
            $0.top.equalToSuperview().offset(20)
            $0.size.equalTo(40)
            $0.leading.equalToSuperview().offset(40)
        })

        titleLabel.snp.makeConstraints({
            $0.leading.equalTo(icon.snp.trailing).offset(10)
            $0.top.equalToSuperview().offset(20)
        })

        bottomLabel.snp.makeConstraints({
            $0.leading.equalTo(icon.snp.trailing).offset(10)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        })

        playPauseButton.snp.makeConstraints({
            $0.size.equalTo(40)
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(40)
        })
    }
}
