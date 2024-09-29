import UIKit

protocol SearchDelegate: AnyObject {
    func search(_ query: String)
}

final class SearchViewController: SpeakerViewController {

    weak var delegate: SearchDelegate?

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 20
        return view
    }()

    private let backSearchView: UIView = {
        let view = UIView()
        view.backgroundColor = .searchGray.withAlphaComponent(0.55)
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var backButton: SpeakerButton = {
        let button = SpeakerButton()
        let normalAttributedString = NSAttributedString(
            string: "BACK",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font : UIFont.poppins(.regular, size: 15)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.setAttributedTitle(normalAttributedString, for: .highlighted)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        return button
    }()

    private lazy var searchButton: SpeakerButton = {
        let button = SpeakerButton()
        let normalAttributedString = NSAttributedString(
            string: "SEARCH",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font : UIFont.poppins(.regular, size: 15)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.setAttributedTitle(normalAttributedString, for: .highlighted)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapSearch), for: .touchUpInside)
        return button
    }()

    private let magniImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .searchMagni
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.font = .poppins(.regular, size: 15)
        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderGray]
        )
        textField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        textField.autocorrectionType = .no
        textField.inputAssistantItem.leadingBarButtonGroups = []
        textField.inputAssistantItem.trailingBarButtonGroups = []
        textField.inputAccessoryView = nil
        return textField
    }()

    private lazy var clearButton: SpeakerButton = {
        let button = SpeakerButton()
        button.backgroundColor = .clear
        button.setImage(.searchClose, for: .normal)
        button.setImage(.searchClose, for: .highlighted)
        button.addTarget(self, action: #selector(tapClear), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hidePlayer(true)
        view.backgroundColor = .black.withAlphaComponent(0.85)

        view.addSubview(backView)
        backView.addSubview(backSearchView)
        backSearchView.addSubview(magniImage)
        backSearchView.addSubview(textField)
        backSearchView.addSubview(clearButton)
        backView.addSubview(backButton)
        backView.addSubview(searchButton)

        backView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(152)
        })

        backSearchView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(36)
            $0.height.equalTo(46)
        })

        magniImage.snp.makeConstraints({
            $0.size.equalTo(18)
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        })

        textField.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(46)
            $0.height.equalTo(40)
        })

        clearButton.snp.makeConstraints({
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        })

        let insetHalf = (deviceWidth - 32)/4
        backButton.snp.makeConstraints({
            $0.height.equalTo(16)
            $0.centerX.equalTo(backView.snp.centerX).offset(-insetHalf)
            $0.top.equalTo(backSearchView.snp.bottom).offset(22)
        })

        searchButton.snp.makeConstraints({
            $0.height.equalTo(16)
            $0.centerX.equalTo(backView.snp.centerX).offset(insetHalf)
            $0.top.equalTo(backSearchView.snp.bottom).offset(26)
        })
    }
}

private extension SearchViewController {

    @objc func tapSearch() {
        guard let text = textField.text else {
            self.dismiss(animated: false)
            return
        }
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != true {
            delegate?.search(textField.text ?? "")
        }
        self.dismiss(animated: false)
    }

    @objc func textChange() {
        if (textField.text?.count ?? 0) > 0 {
            clearButton.isHidden = false
        } else {
            clearButton.isHidden = true
        }
    }

    @objc func tapClear() {
        textField.text = ""
        clearButton.isHidden = true
    }

    @objc func tapBack() {
        self.dismiss(animated: false)
    }
}

