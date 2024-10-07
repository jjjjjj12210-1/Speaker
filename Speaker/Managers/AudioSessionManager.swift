//
//  AudioSessionManager.swift
//  Speaker
//
//  Created by Денис Ледовский on 29.09.2024.
//

import Foundation
import AVFoundation

protocol AudioRouteDelegate: AnyObject {
    func changeRoute(_ isConnected: Bool)
}

protocol PlayerHideDelegate: AnyObject {
    func needHidePlayer(_ isHide: Bool)
}

final class AudioSessionManager {

    static let shared = AudioSessionManager()

    weak var delgate: AudioRouteDelegate?
    weak var playerDelgate: PlayerHideDelegate?

    var currentDevice = ""
    var isConnected = false
    var isAirPlay = false

    func start() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(routeChange),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleInterruption),
                                               name: AVAudioSession.interruptionNotification,
                                               object: AVAudioSession.sharedInstance())

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,
                                                            mode: .default,
                                                            options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setPreferredSampleRate(44100.0)
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(0.005)
            try AVAudioSession.sharedInstance().setActive(true)

            checkRoute()
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }

    func listAvailableAudioDevices() {
        let audioDevices = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.microphone, .external],
            mediaType: .audio,
            position: .unspecified
        ).devices

        for device in audioDevices {
            print("Device name: \(device.localizedName)")
        }
    }
}

private extension AudioSessionManager {

    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }

        if type == .began {
            // Прерывание началось (например, входящий звонок)
            // Здесь вы можете остановить воспроизведение музыки
            print("Воспроизведение остановлено из-за прерывания")
            AudioManager.shared.pause()
        } else if type == .ended {
            // Прерывание закончилось
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // По желанию возобновите воспроизведение
                    print("Воспроизведение возобновлено")
                    AudioManager.shared.play()
                }
            }
        }
    }

    @objc func routeChange(notification: Notification) {
        AudioManager.shared.reinit()
        checkRoute()
    }

    func checkRoute() {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        for output in currentRoute.outputs {
            if output.portType == .airPlay {
                isAirPlay = true
            } else {
                isAirPlay = false
            }

            // Проверяем тип устройства вывода
            if output.portType == .builtInSpeaker {
                print("Аудио воспроизводится через встроенные динамики телефона.")
                isConnected = false
                delgate?.changeRoute(false)
                playerDelgate?.needHidePlayer(true)
            } else {
                isConnected = true
                currentDevice = output.portName
                delgate?.changeRoute(true)
                playerDelgate?.needHidePlayer(false)
            }
        }
    }
}
