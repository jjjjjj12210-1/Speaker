import UIKit

final class HomeBigButton: UIView {

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

    lazy var viewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
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

    func configure(icon: UIImage, title: String) {
        self.icon.image = icon
        titleLabel.text = title
    }

}

//MARK: - Private
private extension HomeBigButton {

}
//MARK: - Constraits
private extension HomeBigButton {

    private func configureConstraints() {

        backgroundColor = .backGray
        layer.cornerRadius = 20

        addSubview(icon)
        addSubview(titleLabel)
        addSubview(viewButton)

        icon.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
            $0.leading.equalToSuperview().offset(14)
        })

        titleLabel.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(icon.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(4)
        })

        viewButton.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}
