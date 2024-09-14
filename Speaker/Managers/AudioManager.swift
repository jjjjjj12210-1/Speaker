import UIKit
import AVFoundation

protocol AudioProtocol: AnyObject {
    func updateTimes(currentTime: Double, remainingTime: Double)
    func setStartTime(fullTime: Double)
    func setNextTrackInfo()
}

final class AudioManager {

    static let shared = AudioManager()
    weak var audioDelegate: AudioProtocol?

    private var audioEngine: AVAudioEngine?
    private var player: AVAudioPlayerNode?
    private var eq: AVAudioUnitEQ?

    var audioFile: AVAudioFile?

    private var timer: Timer?
    private var startTime: TimeInterval?

    var isLoadTrack = false
    var fullDuration: Double = 0
    var currentTime: Double = 0
    var remainingTime: Double = 0
    var isPlayNow = false
    var isRepeateMode = false
    var isMixMode = false

    init() {
        audioEngine = AVAudioEngine()
        player = AVAudioPlayerNode()
        eq = AVAudioUnitEQ(numberOfBands: 2)

        setupEQ()
        setupAudioEngine()
    }
}

extension AudioManager {

    func loadStartTrack(_ url: URL) {
        guard let audioEngine = audioEngine,
              let player = player else {return}

        audioEngine.prepare()

        do {
            let audioFile = try AVAudioFile(forReading: url)

            self.audioFile = audioFile
            player.scheduleFile(audioFile, at: nil)
            fullDuration = getAudioDuration(audioFile: audioFile)
            currentTime = 0
            remainingTime = fullDuration
            audioDelegate?.setStartTime(fullTime: fullDuration)
            isPlayNow = false
            isLoadTrack = true
        } catch {
            print("Ошибка при воспроизведении аудиофайла: \(error)")
        }
    }

    func playAudioFile(_ url: URL) {
        guard let audioEngine = audioEngine,
              let player = player else {return}

        do {
            let audioFile = try AVAudioFile(forReading: url)

//            let format = audioFile.processingFormat
//            audioEngine.connect(player, to: audioEngine.mainMixerNode, format: format)

            self.audioFile = audioFile
            fullDuration = getAudioDuration(audioFile: audioFile)
            currentTime = 0
            remainingTime = fullDuration
            audioDelegate?.setStartTime(fullTime: fullDuration)
            startTime = Date().timeIntervalSince1970
            startTimer()
            isPlayNow = true
            isLoadTrack = true

            player.scheduleFile(audioFile, at: nil, completionHandler: nil)
            player.play()
        } catch {
            print("Ошибка при воспроизведении аудиофайла: \(error)")
        }
    }

    func play() {
        isPlayNow = true
        player?.play()
        startTime = Date().timeIntervalSince1970 - currentTime
        startTimer()
    }

    func pause() {
        isPlayNow = false
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

    //MARK: - Start Seconds
    func playAudio(from startSeconds: TimeInterval) {
        stop()
        currentTime = startSeconds
        guard let audioFile = audioFile,
              let player = player else { return }

        let startFrame = AVAudioFramePosition(startSeconds * audioFile.fileFormat.sampleRate)
        let lengthInFrames = AVAudioFrameCount(audioFile.length - startFrame)

        if startFrame < 0 || startFrame >= audioFile.length {
            print("Error: Start position is out of bounds.")
            return
        }
        //MARK: - этот кложур следит за окончанием трека
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
        guard let audioFile = audioFile,
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

    func getAudioDuration(audioFile: AVAudioFile?) -> Double {
        guard let audioFile = audioFile else {
            return 0
        }

        let lengthInSamples = Double(audioFile.length)
        let sampleRate = audioFile.fileFormat.sampleRate
        return lengthInSamples / sampleRate
    }

    func endTrack() {
        if isRepeateMode {
            guard let url = audioFile?.url else {return}
            playAudioFile(url)
        } else {
            guard let url = Bundle.main.url(forResource: "fon_sound", withExtension: "mp3") else { return }
            do {
                audioFile = try AVAudioFile(forReading: url)
                audioDelegate?.setNextTrackInfo()
                playAudioFile(url)
            } catch {
                print("Ошибка при воспроизведении аудиофайла: \(error)")
            }
        }
    }
}

