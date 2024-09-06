//
//  PlayerViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 05.09.2024.
//

import UIKit

protocol PlayerPresenterOutputInterface: AnyObject {

}

final class PlayerViewController: SpeakerViewController {

    private var presenter: PlayerPresenterInterface?
    private var router: PlayerRouterInterface?

    // MARK: - UI
    
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
        label.font = .poppins(.bold, size: 22)
        label.text = "Music playing"
        label.numberOfLines = 1
        return label
    }()

    private let songImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = .playerLogo
        imageView.contentMode = .scaleToFill

        imageView.layer.cornerRadius = 111
        imageView.layer.masksToBounds = true
        imageView.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        imageView.layer.shadowRadius = 40
        imageView.layer.shadowOffset = CGSize(width: 0, height: 20)

        imageView.layer.shadowOpacity = 1
        imageView.layer.masksToBounds = false
        return imageView
    }()

    private lazy var singerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.bold, size: 35)
        label.text = "Arcade"
        label.numberOfLines = 1
        return label
    }()

    private lazy var songLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white.withAlphaComponent(0.5)
        label.font = .poppins(.bold, size: 22)
        label.text = "Duncan Laurence"
        label.numberOfLines = 1
        return label
    }()

    private lazy var sliderView: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 20
        slider.setThumbImage(.sliderThumb, for: .normal)
        slider.minimumTrackTintColor = .playerGrayLight
        slider.maximumTrackTintColor = .playerGrayDark.withAlphaComponent(0.35)
//        slider.addTarget(self, action: #selector(valueChange), for: .valueChanged)
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        return slider
    }()

    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = .poppins(.bold, size: 15)
        label.text = "1:08"
        label.numberOfLines = 1
        return label
    }()

    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = .poppins(.bold, size: 15)
        label.text = "3:04"
        label.numberOfLines = 1
        return label
    }()

    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(.playerPause, for: .normal)
        button.setImage(.playerPause, for: .highlighted)

        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.35).cgColor
        button.layer.shadowRadius = 30
        button.layer.shadowOffset = CGSize.zero

        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        return button
    }()

    private lazy var repeatButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(.playerRepeat, for: .normal)
        button.setImage(.playerRepeat, for: .highlighted)
        return button
    }()

    private lazy var randomButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(.playerMix, for: .normal)
        button.setImage(.playerMix, for: .highlighted)
        return button
    }()

    // MARK: - Init
    init(presenter: PlayerPresenterInterface, router: PlayerRouterInterface) {
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

// MARK: - PlayerPresenterOutputInterface

extension PlayerViewController: PlayerPresenterOutputInterface {

}

// MARK: - Private

private extension PlayerViewController {

    @objc func tapClose() {
        presenter?.selectClose()
    }

    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("start")
                // handle drag began
            case .moved:
                print(slider.value)
                // handle drag moved
            case .ended:
                print("end")
                // handle drag ended
            default:
                break
            }
        }
    }

//    @objc func valueChange(sender: UISlider?) {
//        print(sender?.value)
//    }

}

// MARK: - UISetup

private extension PlayerViewController {
    func customInit() {

        view.addSubview(topView)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(songImage)
        view.addSubview(singerLabel)
        view.addSubview(songLabel)
        view.addSubview(sliderView)
        view.addSubview(startTimeLabel)
        view.addSubview(endTimeLabel)
        view.addSubview(playPauseButton)
        view.addSubview(repeatButton)
        view.addSubview(randomButton)

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
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(90)
        })

        songImage.snp.makeConstraints({
            $0.size.equalTo(222)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(148)
        })

        singerLabel.snp.makeConstraints({
            $0.top.equalTo(songImage.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(16)
        })

        songLabel.snp.makeConstraints({
            $0.top.equalTo(singerLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        })

        sliderView.snp.makeConstraints({
            $0.top.equalTo(songLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(18)
        })

        startTimeLabel.snp.makeConstraints({
            $0.top.equalTo(sliderView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        })

        endTimeLabel.snp.makeConstraints({
            $0.top.equalTo(sliderView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(16)
        })

        playPauseButton.snp.makeConstraints({
            $0.size.equalTo(77)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(sliderView.snp.bottom).offset(60)
        })

        repeatButton.snp.makeConstraints({
            $0.size.equalTo(30)
            $0.centerY.equalTo(playPauseButton.snp.centerY)
            $0.leading.equalToSuperview().offset(50)
        })

        randomButton.snp.makeConstraints({
            $0.size.equalTo(30)
            $0.centerY.equalTo(playPauseButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(50)
        })
    }
}
