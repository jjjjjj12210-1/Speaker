//
//  AddMusicViewController.swift
//  Speaker
//
//  Created by Денис Ледовский on 03.09.2024.
//

import UIKit
import UniformTypeIdentifiers
import MobileCoreServices
import MediaPlayer


final class AddMusicViewController: SpeakerViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<AddMusicSection, AddMusicModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<AddMusicSection, AddMusicModel>

    private lazy var dataSource = makeDataSource()

    private let audioDataSource = Store.viewContext.audioDataSource

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = 18
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        AddMusicCell.register(collectionView)
        return collectionView
    }()

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
private extension AddMusicViewController {

    func customInit() {
        applySnapshot()
        setNavBar()
        
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(300)
        })
    }

    func makeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            return self.makeSection()
        }, configuration: configuration)
    }

    func makeSection() -> NSCollectionLayoutSection {

        let heightItem: CGFloat = 85
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .absolute(heightItem))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(heightItem))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 3)
        group.interItemSpacing = .fixed(22)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 22
        return section
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = AddMusicCell.getCell(collectionView, for: indexPath)
                cell.configure(item)
                return cell
            })
        return dataSource
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        let sections = AddMusicSection.allSections()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func setMediaPicker() {
        let mediaPicker = MPMediaPickerController(mediaTypes: .anyAudio)
        mediaPicker.showsCloudItems = false
        mediaPicker.showsItemsWithProtectedAssets = true
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false

        self.present(mediaPicker, animated: true, completion: nil)

        MPMediaLibrary.requestAuthorization({(newPermissionStatus: MPMediaLibraryAuthorizationStatus) in
            // This code will be called after the user allows or denies your app permission.
            switch (newPermissionStatus) {
            case MPMediaLibraryAuthorizationStatus.authorized:
                print("permission status is authorized")
            case MPMediaLibraryAuthorizationStatus.notDetermined:
                print("permission status is not determined")
            case MPMediaLibraryAuthorizationStatus.denied:
                print("permission status is denied")
            case MPMediaLibraryAuthorizationStatus.restricted:
                print("permission status is restricted")
            @unknown default: print("Fatal error")
            }
        })
    }
}

// MARK: - Core Data
private extension AddMusicViewController {

    func saveTrackInCoreData(_ track: AudioTrack) {
        DispatchQueue.global(qos: .utility).async {
            Store.viewContext.addAudio(item: track) { result in
                switch result {
                case .fail(let error): print("Error: ", error)
                case .success: print("Succes add \(track.filePath)")
                }
            }
        }
    }
}

//MARK: - UICollectionViewDelegate

extension AddMusicViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let controller = TextInfoViewController(type: .ipad)
            navigationController?.present(controller, animated: true)
        case 1:
            var documentPicker: UIDocumentPickerViewController
            if #available(iOS 14.0, *) {
                let supportedTypes: [UTType] = [UTType.audio]
                documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
            } else {
                documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: UIDocumentPickerMode.import)
            }
            documentPicker.delegate = self

            DispatchQueue.main.async {
                self.present(documentPicker, animated: true, completion: nil)
            }
        case 2:
            if AppHubManager.shared.isPremium {
                setMediaPicker()
            } else {
                let controller = PayWallNewInit.createViewController(isFromStream: false)
                controller.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(controller, animated: true)
            }
        case 3,4,5:
            let controller = TextInfoViewController(type: .dropBox)
            navigationController?.present(controller, animated: true)
        default: return
        }
    }
}

// MARK: - NavBar

private extension AddMusicViewController {
    func setNavBar() {
        navigationItem.title = "Add music"

        let button = SpeakerButton.init(type: .custom)
        let normalAttributedString = NSAttributedString(
            string: "BACK",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.textGrayLight,
                NSAttributedString.Key.font : UIFont.poppins(.regular, size: 12)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.setAttributedTitle(normalAttributedString, for: .highlighted)
        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 20)
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }

    @objc func tapBack() {
        navigationController?.popViewController(animated: false)
    }
}

extension AddMusicViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first,
            selectedFileURL.startAccessingSecurityScopedResource() else { return }
        defer { selectedFileURL.stopAccessingSecurityScopedResource() }

        // Путь к директории Documents вашего приложения
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        // Создаем папку Music в документах, если она не существует
        let musicDirectoryURL = documentsDirectoryURL.appendingPathComponent("MusicFiles")

        do {
            try FileManager.default.createDirectory(at: musicDirectoryURL, withIntermediateDirectories: true, attributes: nil)

            // Путь для сохранения файла
            let destinationURL = musicDirectoryURL.appendingPathComponent(selectedFileURL.lastPathComponent)

            // Копируем файл в папку Music
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: destinationURL)
                print("Файл успешно сохранен в: \(destinationURL)")

                var track = AudioTrack(id: UUID(),
                                       artist: nil,
                                       titleTrack: nil,
                                       logo: nil,
                                       audioFile: nil,
                                       filePath: destinationURL,
                                       date: Date(),
                                       isFile: true)
                Task {
                    do {
                        let audioFile = try AVAudioFile(forReading: destinationURL)
                        let metadata = try await fetchAudioMetadata(from: audioFile.url)
                        track.artist = (metadata.artist ?? "Unknown")
                        track.titleTrack = (metadata.title ?? "Unknown")

                        saveTrackInCoreData(track)

                        do {
                            let audioFile = try AVAudioFile(forReading: destinationURL)
                            track.audioFile = audioFile
                            AudioManager.shared.allTracks.append(track)
                            if AudioManager.shared.allTracks.count == 1 {
                                print("Need load start")
                                AudioManager.shared.loadStartTrack()
                            }
                        } catch {
                            print("Ошибка при попытки формирования АудиоФайла: \(error)")
                        }
                    } catch {
                        print("Ошибка при получении метаданных: \(error)")
                    }
                }
            } catch {
                print("Ошибка при копировании файла: \(error.localizedDescription)")
            }

        } catch {
            print("Ошибка при создании директории: \(error.localizedDescription)")
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Выбор файла отменен")
    }
}

//MARK: - MPMediaPickerControllerDelegate

extension AddMusicViewController: MPMediaPickerControllerDelegate {

    func mediaPicker(_ mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {

        let mediaItems = mediaItemCollection.items
        for mediaItem in mediaItems {

            audioDataSource.fetchTrack(url: mediaItem.assetURL?.absoluteString ?? "") { [self] result in
                switch result {
                case .success:
                    dismiss(animated: true, completion: nil)

                    if audioDataSource.count < 1 {
                        if let title = mediaItem.title,
                           let artist = mediaItem.artist,
                           let logo = mediaItem.artwork?.image(at: CGSize(width: 200, height: 200)) {
                            print("Track Name: \(title)\nArtist Name: \(artist) logo - \(logo)")
                            var track = AudioTrack(id: UUID(),
                                                   artist: artist,
                                                   titleTrack: title,
                                                   logo: logo,
                                                   audioFile: nil,
                                                   filePath: mediaItem.assetURL,
                                                   date: Date(),
                                                   isFile: false)
                            saveTrackInCoreData(track)

                            if let url = mediaItem.value(forProperty: MPMediaItemPropertyAssetURL) as? URL {
                                print(url)
                                do {
                                    let audioFile = try AVAudioFile(forReading: url)
                                    track.audioFile = audioFile
                                    AudioManager.shared.allTracks.append(track)
                                    if AudioManager.shared.allTracks.count == 1 {
                                        print("Need load start")
                                        AudioManager.shared.loadStartTrack()
                                    }
                                } catch {
                                    print("Ошибка при попытки формирования АудиоФайла: \(error)")
                                }
                            }
                        }
                    }
                case .fail(_):  dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
}

private extension AddMusicViewController {

    func fetchAudioMetadata(from url: URL) async throws -> (title: String?, artist: String?) {
        let asset = AVAsset(url: url)
        let metadataItems: [AVMetadataItem] = try await asset.load(.metadata)

        var title: String?
        var artist: String?

        for item in metadataItems {
            if let key = item.commonKey?.rawValue {
                switch key {
                case AVMetadataKey.commonKeyTitle.rawValue:
                    title = try await item.load(.stringValue)
                case AVMetadataKey.commonKeyArtist.rawValue:
                    artist = try await item.load(.stringValue)
                default:
                    break
                }
            }
        }
        return (title, artist)
    }
}
