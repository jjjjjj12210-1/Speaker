import UIKit
import AVFoundation

struct LibraryCellModel {
    let title: String
    let icon: UIImage
}

final class LibraryCell: SpeakerTableCell {

    var didTapPlayPause: (()->())?
    var didTapSettings: (()->())?

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.10)
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(.homePlay, for: .normal)
        button.setImage(.homePlay, for: .highlighted)

        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.white.withAlphaComponent(0.2).cgColor
        button.layer.shadowRadius = 16.0
        button.layer.shadowOffset = CGSize.zero

        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false

        button.addTarget(self, action: #selector(tapPausePlay), for: .touchUpInside)
        return button
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
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var timeLabel: UILabel = {
       let label = UILabel()
        label.font = .poppins(.regular, size: 11)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .white
//        label.text = "4:22"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var editButton: SpeakerButton = {
        let button = SpeakerButton()
        button.backgroundColor = .clear
        button.setImage(.libEdit, for: .normal)
        button.setImage(.libEdit, for: .highlighted)
        button.addTarget(self, action: #selector(tapSetting), for: .touchUpInside)
        return button
    }()

    override func setup() {
        selectionStyle = UITableViewCell.SelectionStyle.none
        contentView.backgroundColor = .baseBlack
        configureConstraints()
    }

    func configure(_ data: AudioTrack) {
        if data.isFile == true {
            Task {
                do {
                    if  let audioURL = data.audioFile?.url {
                        let metadata = try await fetchAudioMetadata(from: audioURL)
                        bottomLabel.text = (metadata.artist ?? "Unknown")
                        titleLabel.text = (metadata.title ?? "Unknown")
                        let duration = AudioManager.shared.getAudioDuration(audioFile: data.audioFile)
                        timeLabel.text = formattedTime(duration)
                    }
                } catch {
                    print("Ошибка при получении метаданных: \(error)")
                }
            }
        } else {
            bottomLabel.text = data.artist
            titleLabel.text = data.titleTrack
            let duration = AudioManager.shared.getAudioDuration(audioFile: data.audioFile)
            timeLabel.text = formattedTime(duration)
        }
    }

    func isPlay(_ isPlay: Bool) {
        if isPlay {
            playPauseButton.setImage(.homePause, for: .normal)
            playPauseButton.setImage(.homePause, for: .highlighted)

            playPauseButton.layer.shadowColor = UIColor.buttonGold.withAlphaComponent(0.2).cgColor
        } else {
            playPauseButton.setImage(.homePlay, for: .normal)
            playPauseButton.setImage(.homePlay, for: .highlighted)

            playPauseButton.layer.shadowColor = UIColor.white.withAlphaComponent(0.2).cgColor
        }
    }
}

private extension LibraryCell {

    @objc func tapPausePlay() {
        didTapPlayPause?()
    }

    @objc func tapSetting() {
        didTapSettings?()
    }

    private func configureConstraints() {

        contentView.addSubview(backView)
        backView.addSubview(playPauseButton)
        backView.addSubview(titleLabel)
        backView.addSubview(bottomLabel)
        backView.addSubview(timeLabel)
        backView.addSubview(editButton)

        backView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(72)
            $0.bottom.equalToSuperview().inset(17)
        })

        playPauseButton.snp.makeConstraints({
            $0.size.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        })

        titleLabel.snp.makeConstraints({
            $0.leading.equalTo(playPauseButton.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(90)
            $0.top.equalToSuperview().offset(16)
        })

        bottomLabel.snp.makeConstraints({
            $0.leading.equalTo(playPauseButton.snp.trailing).offset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(90)
        })

        timeLabel.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(50)
        })

        editButton.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(19)
            $0.height.equalTo(5)
        })
    }

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

    func formattedTime(_ time: Float64) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
