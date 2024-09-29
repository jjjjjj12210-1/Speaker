import UIKit
import AVFoundation

final class HomePlayerView: UIView {

    //MARK: - Property

    private var isPlayNow = false

    //MARK: - UI

    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.image = .playerNoImg
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.semibold, size: 14)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .white
//        label.text = "Different world ..."
        return label
    }()

    private lazy var bottomLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 11)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .textGrayLight
//        label.text = "Alan Walker, K-391 & Sofia"
        return label
    }()

    lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(.homePlay, for: .normal)
        button.setImage(.homePlay, for: .highlighted)

        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        button.layer.shadowRadius = 16.0
        button.layer.shadowOffset = CGSize.zero

        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false

        button.addTarget(self, action: #selector(tapPlayPause), for: .touchUpInside)
        return button
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureConstraints()
        setTrackInfo()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func updatePlay() {
        isPlayNow = AudioManager.shared.isPlayNow
        if AudioManager.shared.isPlayNow {
            playPauseButton.setImage(.homePause, for: .normal)
            playPauseButton.setImage(.homePause, for: .highlighted)
            playPauseButton.layer.shadowColor = UIColor.buttonGold.withAlphaComponent(0.3).cgColor
        } else {
            playPauseButton.setImage(.homePlay, for: .normal)
            playPauseButton.setImage(.homePlay, for: .highlighted)
            playPauseButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        }
    }

    func setTrackInfo() {
        updatePlay()
        if AudioManager.shared.track?.isFile == true {
            Task {
                do {
                    let audioFile = AudioManager.shared.track?.audioFile
                    if  let audioURL = audioFile?.url {
                        let metadata = try await fetchAudioMetadata(from: audioURL)
                        bottomLabel.text = (metadata.artist ?? "Unknown")
                        titleLabel.text = (metadata.title ?? "Unknown")
                        print("Title: \(metadata.title ?? "Unknown")")
                        print("Artist: \(metadata.artist ?? "Unknown")")
                        if let artworkImage = metadata.artwork {
                            icon.image = artworkImage
                        } else {
                            icon.image = .playerNoImg
                        }
                    }
                } catch {
                    print("Ошибка при получении метаданных: \(error)")
                }
            }
        } else {
            bottomLabel.text = AudioManager.shared.track?.artist
            titleLabel.text = AudioManager.shared.track?.titleTrack
            icon.image = AudioManager.shared.track?.logo
        }
    }
}

//MARK: - Private
private extension HomePlayerView {

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

    @objc func tapPlayPause() {
        isPlayNow.toggle()
        switch isPlayNow {
        case true:
            playPauseButton.setImage(.homePause, for: .normal)
            playPauseButton.setImage(.homePause, for: .highlighted)
            playPauseButton.layer.shadowColor = UIColor.buttonGold.withAlphaComponent(0.3).cgColor
            AudioManager.shared.play()
        case false:
            playPauseButton.setImage(.homePlay, for: .normal)
            playPauseButton.setImage(.homePlay, for: .highlighted)
            playPauseButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
            AudioManager.shared.pause()
        }
    }

}

//MARK: - Constraits
private extension HomePlayerView {

    func configureConstraints() {

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
