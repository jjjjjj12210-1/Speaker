import UIKit

final class TextInfoViewController: SpeakerViewController {

    enum TextType {
        case ipad
        case dropBox
    }

    let currentType: TextType

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .topLineGray
        view.layer.cornerRadius = 2
        return view
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        button.setImage(.bcClose, for: .normal)
        button.setImage(.bcClose, for: .highlighted)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .custom(.semibold, size: 18, fontFamily: .lato)
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Init
    init(type: TextType) {
        currentType = type
        super.init(nibName: nil, bundle: nil)
        switch type {
        case .ipad: titleLabel.text = Text.fromIpadTitle
        case .dropBox: titleLabel.text = Text.dropBoxTitle
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - lifecicle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
    }
}

// MARK: - Private
private extension TextInfoViewController {

    func customInit() {
        view.addSubview(topView)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)

        topView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4)
            $0.top.equalToSuperview().offset(6)
            $0.width.equalTo(60)
        })

        closeButton.snp.makeConstraints({
            $0.size.equalTo(37)
            $0.trailing.equalToSuperview().inset(14)
            $0.top.equalToSuperview().offset(21)
        })

        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(86)
            $0.leading.trailing.equalToSuperview().inset(10)
        })

        switch currentType {
        case .ipad: setIPadText()
        case .dropBox: setDropBoxText()
        }
    }

    func setIPadText() {
        let attrs1 = [NSAttributedString.Key.font : UIFont.custom(.regular, size: 14, fontFamily: .lato),
                      NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedString.Key.font : UIFont.custom(.regular, size: 14, fontFamily: .lato),
                      NSAttributedString.Key.foregroundColor : UIColor.white,
                      NSAttributedString.Key.underlineColor : UIColor.white,
                      NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]

        let attString1 = NSMutableAttributedString(string:"Turn on ", attributes: attrs1)
        let attString2 = NSMutableAttributedString(string:"AirDrop", attributes: attrs2)
        let attString3 = NSMutableAttributedString(string:" on iPhone and iPad: Open Control Center > Enable AirDrop > Choose Contacts Only or Everyone.\n\n", attributes: attrs1)
        let attString4 = NSMutableAttributedString(string:"On iPad:", attributes: attrs2)
        let attString5 = NSMutableAttributedString(string:" Open the Files app > Find the song you’d like to share > Hold the icon of song > Click Share Song > AirDrop > Choose iPhone \n\n", attributes: attrs1)
        let attString6 = NSMutableAttributedString(string:"Then On iPhone:", attributes: attrs2)
        let attString7 = NSMutableAttributedString(string:" A pop-up message will appear and click Accept. \n\n", attributes: attrs1)
        let attString8 = NSMutableAttributedString(string:"After that, go to this app again and click on Files button in the previous step. \n\nIn files you can easily import your music files to this app’s library. \n\nSimilarly, using the same procedure, you can transfer a file from a MacBook to an iPhone.", attributes: attrs1)


        attString1.append(attString2)
        attString1.append(attString3)
        attString1.append(attString4)
        attString1.append(attString5)
        attString1.append(attString6)
        attString1.append(attString7)
        attString1.append(attString8)

        let label = UILabel()
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.attributedText = attString1

        view.addSubview(label)

        label.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
        })
    }

    func setDropBoxText() {
        let attrs1 = [NSAttributedString.Key.font : UIFont.custom(.regular, size: 14, fontFamily: .lato),
                      NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedString.Key.font : UIFont.custom(.regular, size: 14, fontFamily: .lato),
                      NSAttributedString.Key.foregroundColor : UIColor.white,
                      NSAttributedString.Key.underlineColor : UIColor.white,
                      NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]

        let attString1 = NSMutableAttributedString(string:"To export a file on the Dropbox, Google Drive, Onebox mobile app on your iPhone: \n\n1. Open the Dropbox, Google Drive or Onebox ", attributes: attrs1)
        let attString2 = NSMutableAttributedString(string:"mobile app.", attributes: attrs2)
        let attString3 = NSMutableAttributedString(string:"\n2. Tap the Files tab. \n3. ", attributes: attrs1)
        let attString4 = NSMutableAttributedString(string:"Search", attributes: attrs2)
        let attString5 = NSMutableAttributedString(string:" your music files. \n4. Save the file locally: \n        • To save the file locally, tap Save to device. \n\nAfter that, go to ", attributes: attrs1)
        let attString6 = NSMutableAttributedString(string:"this app again", attributes: attrs2)
        let attString7 = NSMutableAttributedString(string:" and click on Files button in the previous step. \nIn files you can easily add your music files to this app’s library.", attributes: attrs1)

        attString1.append(attString2)
        attString1.append(attString3)
        attString1.append(attString4)
        attString1.append(attString5)
        attString1.append(attString6)
        attString1.append(attString7)

        let label = UILabel()
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.attributedText = attString1

        view.addSubview(label)

        label.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
        })
    }

    @objc func tapClose() {
        self.dismiss(animated: true)
    }
}
