//
//  PayWallViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 27.08.2024.
//

import UIKit

protocol PayWallPresenterOutputInterface: AnyObject {

}

final class PayWallViewController: SpeakerViewController {

    // MARK: - Property
    private var presenter: PayWallPresenterInterface?
    private var router: PayWallRouterInterface?

    private let heightButton: CGFloat = 78
    private let bottomButtonHeight: CGFloat = 20

    // MARK: - UI

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setImage(UIImage(systemName: "xmark"), for: .highlighted)
        button.tintColor = .white
        button.alpha = 0.8
        button.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        return button
    }()

    private let topImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .payWallTop
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.bold, size: isSmallDevice ? 22 : 26)
        label.text = "Unlimited listening \nall streaming services"
        label.numberOfLines = 2
        return label
    }()

    private let daysLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.regular, size: isSmallDevice ? 13 : 15)
        label.text = "Try 3 days for free"
        label.numberOfLines = 1
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.regular, size: isSmallDevice ? 13 : 15)
        label.text = "Then 9,99$ per month"
        label.numberOfLines = 1
        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .descGray
        label.font = .poppins(.regular, size: 11)
        label.numberOfLines = 1
        label.text = "Auto-renewable subscription. Cancel anytime"
        return label
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .totalBlack
        button.layer.cornerRadius = heightButton/2
        let normalAttributedString = NSAttributedString(
            string: "Continue",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font : UIFont.poppins(.bold, size: 20)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(tapContinue), for: .touchUpInside)

        button.layer.cornerRadius = heightButton/2
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowRadius = 80.0
        button.layer.shadowOffset = CGSize.zero

        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        return button
    }()

    private lazy var ppButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let normalAttributedString = NSAttributedString(
            string: "Privacy",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.descGray,
                NSAttributedString.Key.font : UIFont.poppins(.regular, size: 10)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(tapPP), for: .touchUpInside)
        return button
    }()

    private lazy var restoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let normalAttributedString = NSAttributedString(
            string: "Restore",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.descGray,
                NSAttributedString.Key.font : UIFont.poppins(.regular, size: 10)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(tapRestore), for: .touchUpInside)
        return button
    }()

    private lazy var termButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let normalAttributedString = NSAttributedString(
            string: "Terms of use",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.descGray,
                NSAttributedString.Key.font : UIFont.poppins(.regular, size: 10)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(tapTerm), for: .touchUpInside)
        return button
    }()

    // MARK: - init
    init(presenter: PayWallPresenterInterface, router: PayWallRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
        hidePlayer(true)
    }
}

// MARK: - PayWallPresenterOutputInterface

extension PayWallViewController: PayWallPresenterOutputInterface {

}

// MARK: - Private
private extension PayWallViewController {
    //TODO: - Buy
    @objc func tapContinue() {

    }

    @objc func tapPP() {
        presenter?.selectPP()
    }

    //TODO: - Restor
    @objc func tapRestore() {

    }

    @objc func tapTerm() {
        presenter?.selectTerm()
    }

    @objc func tapClose() {
        let appCoordinator = AppCoordinator()
        appCoordinator.showMain()
    }
}

// MARK: - UISetup

private extension PayWallViewController {
    func customInit() {
        view.backgroundColor = .baseBlack

        view.addSubview(closeButton)
        view.addSubview(topImage)
        view.addSubview(titleLabel)
        view.addSubview(daysLabel)
        view.addSubview(priceLabel)
        view.addSubview(descLabel)
        view.addSubview(ppButton)
        view.addSubview(restoreButton)
        view.addSubview(termButton)

        view.addSubview(continueButton)

        closeButton.snp.makeConstraints({
            $0.size.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.trailing.equalToSuperview().inset(10)
        })

        let height = deviceWidth * 1.19786096
        topImage.snp.updateConstraints({
            $0.top.equalToSuperview().offset(isSmallDevice ? -80 : -60)
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.height.equalTo(height)
        })

        titleLabel.snp.updateConstraints({
            $0.bottom.equalToSuperview().inset(isSmallDevice ? 240 : 310)
            $0.centerX.equalToSuperview()
        })

        daysLabel.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(isSmallDevice ? 20 : 30)
            $0.centerX.equalToSuperview()
        })

        priceLabel.snp.makeConstraints({
            $0.top.equalTo(daysLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        })

        descLabel.snp.makeConstraints({
            $0.top.equalTo(priceLabel.snp.bottom).offset(isSmallDevice ? 10 : 20)
            $0.centerX.equalToSuperview()
        })

        continueButton.snp.makeConstraints({
            $0.height.equalTo(heightButton)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(isSmallDevice ? 40 : 84)
        })

        let bottomButtonWidth = (deviceWidth - 100)/3
        ppButton.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(bottomButtonHeight)
            $0.width.equalTo(bottomButtonWidth - 10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(isSmallDevice ? -20 : -10)
        })

        termButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.height.equalTo(bottomButtonHeight)
            $0.width.equalTo(bottomButtonWidth + 10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(isSmallDevice ? -20 : -10)
        })

        restoreButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(bottomButtonHeight)
            $0.width.equalTo(bottomButtonWidth - 10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(isSmallDevice ? -20 : -10)
        })

    }
}
