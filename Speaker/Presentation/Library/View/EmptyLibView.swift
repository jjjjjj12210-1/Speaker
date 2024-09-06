import UIKit

final class EmptyLibView: UIView {

    //MARK: - Property


    //MARK: - UI

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.bold, size: 26)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.text = "No music \nfound on your phone"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var bottomLabel: UILabel = {
       let label = UILabel()

        let attrs1 = [NSAttributedString.Key.font : UIFont.poppins(.regular, size: 14),
                      NSAttributedString.Key.foregroundColor : UIColor.textGrayLight]
        let attrs2 = [NSAttributedString.Key.font : UIFont.poppins(.regular, size: 14),
                      NSAttributedString.Key.foregroundColor : UIColor.white,
                      NSAttributedString.Key.underlineColor : UIColor.white,
                      NSAttributedString.Key.underlineStyle :  NSUnderlineStyle.single.rawValue]


        let attString1 = NSMutableAttributedString(string:"Import music files and listen offline\nDon’t know how? ",
                                                          attributes: attrs1)
        let attString2 = NSMutableAttributedString(string:"Read this", attributes: attrs2)
        attString1.append(attString2)
        label.attributedText = attString1
        label.numberOfLines = 2
        label.textAlignment = .center
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
}

//MARK: - Private
private extension EmptyLibView {

}

//MARK: - Constraits
private extension EmptyLibView {

    private func configureConstraints() {

        backgroundColor = .clear

        addSubview(titleLabel)
        addSubview(bottomLabel)
        addSubview(viewButton)

        titleLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.snp.centerY)
        })

        bottomLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        })

        viewButton.snp.makeConstraints({
            $0.edges.equalTo(bottomLabel.snp.edges)
        })
    }
}
