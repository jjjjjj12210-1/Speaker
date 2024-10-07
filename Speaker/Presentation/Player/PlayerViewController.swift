//
//  PlayerViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 05.09.2024.
//

import UIKit
import AVFoundation

protocol PlayerPresenterOutputInterface: AnyObject {

}

final class PlayerViewController: SpeakerViewController {

    private var presenter: PlayerPresenterInterface?
    private var router: PlayerRouterInterface?

    private var audioManager = AudioManager.shared

    private var isLoadTrack = false
    private var isPlayNow = false
    private var isDragSlider = false
    private var isRepeat = false
    private var isMix = false

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
        imageView.image = .playerNoImg
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 111
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray

        view.layer.cornerRadius = 111
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        view.layer.shadowRadius = 40
        view.layer.shadowOffset = CGSize(width: 0, height: 20)

        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
        return view
    }()

    private lazy var singerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.bold, size: 35)
        label.numberOfLines = 1
        return label
    }()

    private lazy var songLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white.withAlphaComponent(0.5)
        label.font = .poppins(.bold, size: 22)
        label.numberOfLines = 1
        return label
    }()

    private lazy var sliderView: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.setThumbImage(.sliderThumb, for: .normal)
        slider.minimumTrackTintColor = .playerGrayLight
        slider.maximumTrackTintColor = .playerGrayDark.withAlphaComponent(0.35)
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        return slider
    }()

    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        return label
    }()

    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        return label
    }()

    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(.playerPlay, for: .normal)
        button.setImage(.playerPlay, for: .highlighted)

        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.35).cgColor
        button.layer.shadowRadius = 30
        button.layer.shadowOffset = CGSize.zero

        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false

        button.addTarget(self, action: #selector(tapPlayStop), for: .touchUpInside)
        return button
    }()

    private lazy var repeatButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .white.withAlphaComponent(0.5)
        button.setImage(.playerRepeat, for: .normal)
        button.setImage(.playerRepeat, for: .highlighted)
        button.addTarget(self, action: #selector(tapRepeat), for: .touchUpInside)
        return button
    }()

    private lazy var randomButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .white.withAlphaComponent(0.5)
        button.setImage(.playerMix, for: .normal)
        button.setImage(.playerMix, for: .highlighted)
        button.addTarget(self, action: #selector(tapMix), for: .touchUpInside)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.viewWillDisappear(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
        hidePlayer(true)
        audioManager.audioDelegate = self
        
        setAudioInfo()
        setTrackInfo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }
}

// MARK: - PlayerPresenterOutputInterface

extension PlayerViewController: PlayerPresenterOutputInterface {

}

// MARK: - Private

private extension PlayerViewController {

    private func setAudioInfo() {
        isPlayNow = audioManager.isPlayNow
        isLoadTrack = audioManager.isLoadTrack
        isMix = audioManager.isMixMode
        isRepeat = audioManager.isRepeateMode
        
        randomButton.tintColor = isMix ? .white : .white.withAlphaComponent(0.5)
        repeatButton.tintColor = isRepeat ? .white : .white.withAlphaComponent(0.5)

        if audioManager.isLoadTrack {
            startTimeLabel.text = formattedTime(audioManager.currentTime)
            endTimeLabel.text = formattedTime(audioManager.remainingTime)
            sliderView.maximumValue = Float(audioManager.fullDuration)
            sliderView.value = Float(audioManager.currentTime)
            sliderView.isUserInteractionEnabled = true

            if audioManager.isPlayNow {
                playPauseButton.setImage(.playerPause, for: .normal)
                playPauseButton.setImage(.playerPause, for: .highlighted)
            } else {
                playPauseButton.setImage(.playerPlay, for: .normal)
                playPauseButton.setImage(.playerPlay, for: .highlighted)
            }
        } else {
            if audioManager.currentTime == 0 && audioManager.remainingTime == 0 {
                startTimeLabel.text = "00:00"
                endTimeLabel.text = "00:00"
                sliderView.value = 0
                sliderView.isUserInteractionEnabled = false
            } else {
                startTimeLabel.text = formattedTime(audioManager.currentTime)
                endTimeLabel.text = formattedTime(audioManager.remainingTime)
                sliderView.value = Float(audioManager.currentTime)
                sliderView.isUserInteractionEnabled = true
            }
        }
    }

    @objc func tapMix() {
        isMix.toggle()
        audioManager.isMixMode = isMix
        randomButton.tintColor = isMix ? .white : .white.withAlphaComponent(0.5)
    }

    @objc func tapRepeat() {
        isRepeat.toggle()
        audioManager.isRepeateMode = isRepeat
        repeatButton.tintColor = isRepeat ? .white : .white.withAlphaComponent(0.5)
    }

    @objc func tapPlayStop() {
        isPlayNow.toggle()
        switch isPlayNow {
        case true:
            playPauseButton.setImage(.playerPause, for: .normal)
            playPauseButton.setImage(.playerPause, for: .highlighted)
            if isLoadTrack {
                audioManager.play()
            }
        case false:
            playPauseButton.setImage(.playerPlay, for: .normal)
            playPauseButton.setImage(.playerPlay, for: .highlighted)
            audioManager.pause()
        }
    }

    func setTrackInfo() {
        if AudioManager.shared.track?.isFile == true {
            Task {
                do {
                    let audioFile = audioManager.track?.audioFile
                    if  let audioURL = audioFile?.url {

                        let metadata = try await fetchAudioMetadata(from: audioURL)
                        singerLabel.text = (metadata.artist ?? "Unknown")
                        songLabel.text = (metadata.title ?? "Unknown")
                        print("Title: \(metadata.title ?? "Unknown")")
                        print("Artist: \(metadata.artist ?? "Unknown")")
                        if let artworkImage = metadata.artwork {
                            songImage.image = artworkImage
                        } else {
                            songImage.image = .playerNoImg
                        }
                    }
                } catch {
                    print("Ошибка при получении метаданных: \(error)")
                }
            }
        } else if AudioManager.shared.track?.isFile == false {
            singerLabel.text = AudioManager.shared.track?.artist
            songLabel.text = AudioManager.shared.track?.titleTrack
            songImage.image = AudioManager.shared.track?.logo
        }
    }


    @objc func tapClose() {
        presenter?.selectClose()
    }

    //MARK: - Slider
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began: isDragSlider = true
            case .moved: return
            case .ended:
                print(slider.value)
                isDragSlider = false
                audioManager.playAudio(from: TimeInterval(slider.value))
                startTimeLabel.text = formattedTime(Float64(slider.value))
                let endTime = slider.maximumValue - slider.value
                endTimeLabel.text = formattedTime(Float64(endTime))
            default:
                break
            }
        }
    }

    func formattedTime(_ time: Float64) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - MetaData
extension PlayerViewController {

//    func getTrackInfo(from asset: AVAsset) -> (trackName: String?, artistName: String?) {
//        var trackName: String?
//        var artistName: String?
//
//        // Извлекаем метаданные из AVAsset
//        let metadata = asset.metadata
//
//        for item in metadata {
//            if let key = item.commonKey?.rawValue {
//                switch key {
//                case AVMetadataKey.commonKeyTitle.rawValue:
//                    trackName = item.stringValue
//                case AVMetadataKey.commonKeyArtist.rawValue:
//                    artistName = item.stringValue
//                default:
//                    continue
//                }
//            }
//        }
//
//        return (trackName, artistName)
//    }

    func fetchAudioMetadata(from url: URL) async throws -> (title: String?, artist: String?, artwork: UIImage?) {
        let asset = AVAsset(url: url)
        let metadataItems: [AVMetadataItem] = try await asset.load(.metadata)

        var title: String?
        var artist: String?
        var artwork: UIImage?

        for item in metadataItems {
            if let key = item.commonKey?.rawValue {
                switch key {
                case AVMetadataKey.commonKeyTitle.rawValue:
                    title = try await item.load(.stringValue)
                case AVMetadataKey.commonKeyArtist.rawValue:
                    artist = try await item.load(.stringValue)
                case AVMetadataKey.commonKeyArtwork.rawValue:
                    if let data = try await item.load(.dataValue) {
                        if let image = UIImage(data: data) {
                            artwork = image
                        }
                    }
                default:
                    break
                }
            }
        }
        return (title, artist, artwork)
    }
}

// MARK: - AudioProtocol
extension PlayerViewController: AudioProtocol {
    func setNextTrackInfo() {
        setTrackInfo()
    }
    
    func setStartTime(fullTime: Double) {
        sliderView.value = 0
        sliderView.maximumValue = Float(fullTime)
        startTimeLabel.text = "00:00"
        endTimeLabel.text = formattedTime(fullTime)
        sliderView.isUserInteractionEnabled = true
    }
    
    func updateTimes(currentTime: Double, remainingTime: Double) {
        startTimeLabel.text = formattedTime(audioManager.currentTime)
        endTimeLabel.text = formattedTime(audioManager.remainingTime)
        if !isDragSlider {
            sliderView.value = Float(currentTime)
        }
    }
}

// MARK: - UISetup

private extension PlayerViewController {
    func customInit() {

        view.addSubview(topView)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(shadowView)
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

        shadowView.snp.makeConstraints({
            $0.size.equalTo(222)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(148)
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
