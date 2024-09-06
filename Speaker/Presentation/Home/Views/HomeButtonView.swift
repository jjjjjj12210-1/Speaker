import UIKit

final class HomeButtonView: UIView {

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
        label.font = .poppins(.semibold, size: 12)
        label.numberOfLines = 1
        label.textAlignment = .center
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
private extension HomeButtonView {

}
//MARK: - Constraits
private extension HomeButtonView {

    private func configureConstraints() {

        backgroundColor = .backGray
        layer.cornerRadius = 20

        addSubview(icon)
        addSubview(titleLabel)
        addSubview(viewButton)

        icon.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.size.equalTo(27)
            $0.bottom.equalTo(self.snp.centerY)
        })

        titleLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(icon.snp.bottom).offset(6)
        })

        viewButton.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}
