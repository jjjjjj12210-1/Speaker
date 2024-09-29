import UIKit
import AVFoundation

struct AudioTrack {
    let id: UUID
    var artist: String?
    var titleTrack: String?
    var logo: UIImage?
    var audioFile: AVAudioFile?
    let filePath: URL?
    let date: Date
    let isFile: Bool
}

//MARK: - AudioProtocol
protocol AudioProtocol: AnyObject {
    func updateTimes(currentTime: Double, remainingTime: Double)
    func setStartTime(fullTime: Double)
    func setNextTrackInfo()
}

//MARK: - BottomPlayerProtocol
protocol BottomPlayerProtocol: AnyObject {
    func setNextAudioInfo()
    func setPlayNoPlay(_ isPlay: Bool)
}

//MARK: - LibraryProtocol
protocol LibraryProtocol: AnyObject {
    func needUpdateTable(_ index: Int, id: UUID)
}

final class AudioManager {

    static let shared = AudioManager()

    weak var audioDelegate: AudioProtocol?
    weak var homePlayerDelegate: BottomPlayerProtocol?
    weak var libraryDelegate: LibraryProtocol?

    //MARK: - Property
    private var audioEngine: AVAudioEngine?
    private var player: AVAudioPlayerNode?
    private var eq: AVAudioUnitEQ?

    var track: AudioTrack?
    var allTracks = [AudioTrack]() {
        didSet {
            allIndexis = allTracks.enumerated().map { $0.offset }
            allIndexis.shuffle()
        }
    }
    var allIndexis = [Int]()
    var currentIndex = 0
    private let audioDataSource = Store.viewContext.audioDataSource

    private var timer: Timer?
    private var startTime: TimeInterval?

    var isLoadTrack = false
    var fullDuration: Double = 0
    var currentTime: Double = 0
    var remainingTime: Double = 0
    var isPlayNow = false {
        didSet {
            homePlayerDelegate?.setPlayNoPlay(isPlayNow)
        }
    }
    
    var isRepeateMode = false
    var isMixMode = false

    //MARK: - init
    init() {
        audioEngine = AVAudioEngine()
        player = AVAudioPlayerNode()
        eq = AVAudioUnitEQ(numberOfBands: 2)

        setupEQ()
        setupAudioEngine()
    }
}

//MARK: - Public Methods
extension AudioManager {

    func loadStartTrack() {
        guard let audioEngine = audioEngine,
              let player = player else {return}

        audioEngine.prepare()

        track = allTracks.first
        if let file = track?.audioFile {
            player.scheduleFile(file, at: nil)
            fullDuration = getAudioDuration(audioFile: file)
            currentTime = 0
            remainingTime = fullDuration
            audioDelegate?.setStartTime(fullTime: fullDuration)
            homePlayerDelegate?.setNextAudioInfo()
            isPlayNow = false
            isLoadTrack = true
        }
    }

    func playAudioFile(_ url: URL) {
        guard let player = player else {return}

        do {
            let audioFile = try AVAudioFile(forReading: url)

            fullDuration = getAudioDuration(audioFile: audioFile)
            currentTime = 0
            remainingTime = fullDuration
            audioDelegate?.setStartTime(fullTime: fullDuration)
            startTime = Date().timeIntervalSince1970
            startTimer()
            isPlayNow = true
            isLoadTrack = true
            libraryDelegate?.needUpdateTable(currentIndex, id: track?.id ?? UUID())

            player.scheduleFile(audioFile, at: nil, completionHandler: nil)
            player.play()
        } catch {
            print("Ошибка при воспроизведении аудиофайла: \(error)")
        }
    }

    func play() {
        isPlayNow = true
        libraryDelegate?.needUpdateTable(currentIndex, id: track?.id ?? UUID())
        player?.play()
        startTime = Date().timeIntervalSince1970 - currentTime
        startTimer()
    }

    func pause() {
        isPlayNow = false
        libraryDelegate?.needUpdateTable(currentIndex, id: track?.id ?? UUID())
        player?.pause()
        timer?.invalidate()
        stopTimer()
    }

    func stop() {
        player?.stop()
        startTime = 0
        stopTimer()
    }

    func setVolume(_ volume: Float) {
        player?.volume = volume
    }

    func setBassLevel(_ level: Float) {
        eq?.bands[0].gain = level
    }

    func setTrebleLevel(_ level: Float) {
        eq?.bands[1].gain = level
    }

    func getBassGain() -> Float {
        guard let eq = eq else {return 0}
        return eq.bands[0].gain
    }

    func getTrebleGain() -> Float {
        guard let eq = eq else {return 0}
        return eq.bands[1].gain
    }

    func getVolumeGain() -> Float {
        guard let player = player else {return 0}
        return player.volume
    }

    func getAudioDuration(audioFile: AVAudioFile?) -> Double {
        guard let audioFile = audioFile else {
            return 0
        }

        let lengthInSamples = Double(audioFile.length)
        let sampleRate = audioFile.fileFormat.sampleRate
        return lengthInSamples / sampleRate
    }

    func selectMusicFromLibrary(index: Int, isSearch: Bool = false, id: UUID = UUID()) {
        var selectIndex = index
        if isSearch {
            guard let index = allTracks.firstIndex(where: {$0.id == id}) else {return}
            selectIndex = index
        }
        guard let url = allTracks[selectIndex].audioFile?.url else {return}
        stop()
        track = allTracks[selectIndex]
        currentIndex = selectIndex
        audioDelegate?.setNextTrackInfo()
        homePlayerDelegate?.setNextAudioInfo()
        if !isPlayNow {
            isPlayNow = true
        }
        playAudioFile(url)
    }

    func trackDelete(_ index: Int) {
        if let url = allTracks[index].filePath,
           allTracks[index].isFile {
            deleteFile(at: url)
        }

        if currentIndex == index {
            stop()
        }

        allTracks.remove(at: index)

        if currentIndex == index && !allTracks.isEmpty {
            loadStartTrack()
        } else if allTracks.isEmpty {
            track = nil
        }
    }

    //MARK: - Start Seconds
    func playAudio(from startSeconds: TimeInterval) {
        stop()
        currentTime = startSeconds
        guard let audioFile = track?.audioFile,
              let player = player else { return }

        let startFrame = AVAudioFramePosition(startSeconds * audioFile.fileFormat.sampleRate)
        let lengthInFrames = AVAudioFrameCount(audioFile.length - startFrame)

        if startFrame < 0 || startFrame >= audioFile.length {
            print("Error: Start position is out of bounds.")
            return
        }
        player.scheduleSegment(audioFile, startingFrame: startFrame, frameCount: lengthInFrames, at: nil) {
            print("Воспроизведение завершено")
        }
        player.play()
        startTime = Date().timeIntervalSince1970 - currentTime
        startTimer()
    }
}

//MARK: - Private
private extension AudioManager {
    private func setupEQ() {
        // Настроим первую полосу эквалайзера для басов
        let bassBand = eq?.bands[0]
        bassBand?.filterType = .lowShelf
        bassBand?.frequency = 80.0 // Частота басов
        bassBand?.gain = 0.0 // Уровень басов (от -24 до 24 дБ)
        bassBand?.bypass = false

        // Настроим вторую полосу эквалайзера для высоких частот
        let trebleBand = eq?.bands[1]
        trebleBand?.filterType = .highShelf
        trebleBand?.frequency = 5000.0 // Частота высоких частот
        trebleBand?.gain = 0.0 // Уровень высоких частот (от -24 до 24 дБ)
        trebleBand?.bypass = false
    }

    private func setupAudioEngine() {
        guard let audioEngine = audioEngine,
              let player = player,
              let eq = eq else {return}

        audioEngine.attach(player)
        audioEngine.attach(eq)

        // Соединяем узлы
        audioEngine.connect(player, to: eq, format: nil)
        audioEngine.connect(eq, to: audioEngine.mainMixerNode, format: nil)
        startEngine()
    }

    private func startEngine() {
        do {
            try audioEngine?.start()
        } catch {
            print("Ошибка при запуске аудио двигателя: \(error)")
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil, repeats: true)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc func updateTime() {
        guard let audioFile = track?.audioFile,
              let startTime = startTime else { return }

        let currentTime = Date().timeIntervalSince1970 - startTime
        let durationInSeconds = Double(audioFile.length) / audioFile.fileFormat.sampleRate
        let remainingTime = durationInSeconds - currentTime

        self.currentTime = currentTime
        self.remainingTime = remainingTime

        if remainingTime <= 0 {
            timer?.invalidate()
            endTrack()
        } else {
            audioDelegate?.updateTimes(currentTime: self.currentTime, remainingTime: self.remainingTime)
        }
    }

    func endTrack() {
        if isRepeateMode {
            guard let url = track?.audioFile?.url else {return}
            playAudioFile(url)
        } else {
            if isMixMode {
                currentIndex = allIndexis[currentIndex]
            } else {
                currentIndex += 1
                if currentIndex >= allTracks.count {
                    currentIndex = 0
                }
            }
            guard let url = allTracks[currentIndex].filePath else { return }
            track = allTracks[currentIndex]
            audioDelegate?.setNextTrackInfo()
            homePlayerDelegate?.setNextAudioInfo()
            libraryDelegate?.needUpdateTable(currentIndex, id: track?.id ?? UUID())
            playAudioFile(url)
        }
    }
}

//MARK: - Files
extension AudioManager {

    func loadAllTrack() {
        audioDataSource.fetch { result in
            switch result {
            case .fail(let error): print("Error: ", error)
            case .success: print("Success fetch. Count = \(self.audioDataSource.count)")
                guard self.audioDataSource.count > 0 else {
                    print("No tracks")
                    return
                }
                let allTarck = self.audioDataSource.getAudioList()
                allTarck.forEach({
                    print($0.url)
                    if $0.isFile {
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let musicDirectory = documentsDirectory.appendingPathComponent("MusicFiles").path

                        if let url = self.getFileURL(inDirectory: musicDirectory, fileName: $0.url) {
                            do {
                                let audioFile = try AVAudioFile(forReading: url)
                                let track = AudioTrack(id: $0.id,
                                                       artist: $0.artist,
                                                       titleTrack: $0.title,
                                                       logo: nil,
                                                       audioFile: audioFile,
                                                       filePath: url,
                                                       date: $0.date,
                                                       isFile: true)
                                self.allTracks.append(track)
                            } catch {
                                print("Ошибка при формирования файла из Папки: \(error)")
                            }
                        }

                    } else {
                        if let url = URL(string: $0.url) {
                            var imageFromCD: UIImage = .playerNoImg
                            if let imgData = $0.logo {
                                imageFromCD = UIImage(data: imgData) ?? .playerNoImg
                            }
                            do {
                                let audioFile = try AVAudioFile(forReading: url)
                                let track = AudioTrack(id: $0.id,
                                                       artist: $0.wrappedArtist,
                                                       titleTrack: $0.wrappedTitle,
                                                       logo: imageFromCD,
                                                       audioFile: audioFile,
                                                       filePath: url,
                                                       date: $0.date,
                                                       isFile: false)
                                self.allTracks.append(track)
                            } catch {
                                print("Ошибка при формировании файла из Медиа: \(error)")
                            }
                        }
                    }
                })
                self.track = self.allTracks.first
                if let url = self.track?.filePath {
                    AudioManager.shared.loadStartTrack()
                }
            }
        }
    }

    func getFileURL(inDirectory directory: String, fileName: String) -> URL? {
        let fileManager = FileManager.default

        // Получаем URL для директории
        let directoryURL = URL(fileURLWithPath: directory)

        // Создаем URL для указанного файла
        let fileURL = directoryURL.appendingPathComponent(fileName)

        // Проверяем, существует ли файл по данному URL
        if fileManager.fileExists(atPath: fileURL.path) {
            return fileURL
        } else {
            print("Файл \(fileName) не существует в указанной директории.")
            return nil
        }
    }

    func deleteFile(at url: URL) {
        let fileManager = FileManager.default

        do {
            // Проверяем, существует ли файл по указанному URL
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
                print("Файл успешно удалён: \(url.path)")
            } else {
                print("Файл не существует по указанному пути: \(url.path)")
            }
        } catch {
            print("Ошибка при удалении файла: \(error.localizedDescription)")
        }
    }
}
