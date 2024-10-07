import UIKit
import StoreKit
import Lottie

struct WelcomeStruct {
    let title: String
    let desc: String
}

final class WelcomeViewController: SpeakerViewController {

    private let titles = [WelcomeStruct(title: "Connect \nand control",
                                        desc: "Easily sync speakers and take \ncharge of audio environment."),
                          WelcomeStruct(title: "Streaming \nwithout interference",
                                        desc: "Connect the speaker in \nany convenient way."),
                          WelcomeStruct(title: "Any online \nplatforms",
                                        desc: "Start the fun with music from \nyour favorite websites."),
                          WelcomeStruct(title: "Customize \nyour listening",
                                        desc: "Adjust volume, bass, treble, \nand more to suit preferences."),
    ]

    private var circleArray = [UIView]()
    private let heightButton: CGFloat = 78
    private var currentWelcomeIndex = 0

    //MARK: - UI

    private let topImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .welcomeTop0
        return imageView
    }()

//    private let bottomImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = .welcomeBottom2
//        imageView.alpha = 0
//        imageView.contentMode = .scaleToFill
//        return imageView
//    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.bold, size: isSmallDevice ? 22 : 26)
        label.text = "Welcome to \nsound experience"
        label.numberOfLines = 2
        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .descGray
        label.font = .poppins(.regular, size: 14)
        label.numberOfLines = 2
        return label
    }()

    private lazy var startAnimation: AnimationView = {
        let lottieView = AnimationView(name: "animation_speaker_control")
        lottieView.loopMode = .loop
        lottieView.play()
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.contentMode = .scaleAspectFit
        return lottieView
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
        button.alpha = 0
        button.addTarget(self, action: #selector(tapContinue), for: .touchUpInside)

        button.layer.cornerRadius = heightButton/2
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.white.withAlphaComponent(0.5).cgColor
        button.layer.shadowRadius = 40.0
        button.layer.shadowOffset = CGSize.zero

        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        return button
    }()

    private let gradientView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()

    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.locations = [0.1, 0.5, 1]
        gradient.colors = [UIColor.white.withAlphaComponent(0.0001).cgColor,
                           UIColor.white.withAlphaComponent(0.35).cgColor,
                           UIColor.white.withAlphaComponent(0.1).cgColor]
        return gradient
    }()

    //MARK: - Lifecicle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame.size = gradientView.frame.size
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        hidePlayer(true)
    }
}

//MARK: - Private
private extension WelcomeViewController {

    func customInit() {
        setViews()
        view.backgroundColor = .baseBlack
        view.isAccessibilityElement = false

        circleArray.forEach({ circle in
            circle.snp.makeConstraints({
                $0.centerY.equalTo(view.snp.top).inset(-6)
                $0.leading.trailing.equalToSuperview().inset(12)
                $0.height.equalTo(((deviceWidth - 20) * 0.54)*2)
            })
        })

        view.addSubview(topImage)
        view.addSubview(titleLabel)
        view.addSubview(descLabel)
        view.addSubview(startAnimation)
        view.addSubview(gradientView)
        gradientView.layer.addSublayer(gradient)
        view.addSubview(continueButton)

        let height = (deviceWidth - 20) * 0.53824362
        topImage.snp.makeConstraints({
            $0.top.equalToSuperview().offset(0)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(height)
        })

        titleLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview().inset(isSmallDevice ? 140 : 178)
            $0.centerX.equalToSuperview()
        })

        startAnimation.snp.makeConstraints({
            $0.size.equalTo(150)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(isSmallDevice ? 0 : 28)
        })

        descLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(isSmallDevice ? 14 : 34)
        })

        gradientView.snp.makeConstraints({
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(isSmallDevice ? 210 : 246)
        })

        continueButton.snp.makeConstraints({
            $0.height.equalTo(heightButton)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(isSmallDevice ? 20 : 84)
        })

        waveAnimation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.setContent()
        }
    }

    func setViews() {
        for _ in 0...100 {
            let circle = UIView()
            circle.backgroundColor = .baseBlack
            circle.layer.cornerRadius = (deviceWidth - 20) * 0.5
            circle.alpha = 0
            circle.layer.borderWidth = 1
            circle.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            circleArray.append(circle)
            view.addSubview(circle)
        }
    }

    func waveAnimation() {
        var delay: TimeInterval = 0
        let scale = isSmallDevice ? 1.5 : 2.5
        circleArray.forEach({ circle in
            circle.alpha = 1
            UIView.animate(withDuration: 7, delay: delay) {
                circle.transform = CGAffineTransform(scaleX: scale, y: scale)
                circle.alpha = 0
            }
            delay += 0.9
        })
    }

    @objc func tapContinue() {
        if currentWelcomeIndex < 4 {
            setContent()
        } else {
            UserSettings.isUsualLaunch = true
            let appCoordinator = AppCoordinator()
            appCoordinator.showPayWAll()
        }
    }

    func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    func setContent() {
        titleLabel.text = titles[currentWelcomeIndex].title
        descLabel.text = titles[currentWelcomeIndex].desc

        switch currentWelcomeIndex {
        case 0:
            titleLabel.snp.updateConstraints({
                $0.bottom.equalToSuperview().inset(isSmallDevice ? 234 : 294)
                $0.centerX.equalToSuperview()
            })
            startAnimation.stop()
            startAnimation.removeFromSuperview()
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2) {
                self.continueButton.alpha = 1
                self.view.layoutIfNeeded()
            }

        case 1:
            rateApp()
            circleArray.forEach({
                $0.removeFromSuperview()
            })
            let height = deviceWidth * 1.19786096
            topImage.snp.updateConstraints({
                $0.top.equalToSuperview().offset(isSmallDevice ? -80 : -60)
                $0.leading.trailing.equalToSuperview().inset(0)
                $0.height.equalTo(height)
            })
            topImage.image = .welcomeTop1
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2) {
                self.continueButton.layer.shadowColor = UIColor.white.withAlphaComponent(0.8).cgColor
                self.continueButton.layer.shadowRadius = 60.0
                self.view.layoutIfNeeded()
            }
        case 2:
            let height = deviceWidth * 1.0347593
            topImage.snp.remakeConstraints({
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(isSmallDevice ? -40 : 6)
                $0.leading.trailing.equalToSuperview().inset(0)
                $0.height.equalTo(height)
            })
            topImage.image = .welcomeTop2
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2) {
                self.gradientView.alpha = 1
                self.continueButton.layer.shadowColor = UIColor.white.withAlphaComponent(0.9).cgColor
                self.continueButton.layer.shadowRadius = 70.0
                self.view.layoutIfNeeded()
            }
        case 3:
            let height = isSmallDevice ? 320 : deviceWidth - 24
            topImage.snp.remakeConstraints({
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
                $0.leading.trailing.equalToSuperview().inset(isSmallDevice ? 20 : 12)
                $0.height.equalTo(height)
            })
            topImage.image = .welcomeTop3
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2) {
                self.continueButton.layer.shadowColor = UIColor.white.withAlphaComponent(1).cgColor
                self.continueButton.layer.shadowRadius = 80.0
                self.view.layoutIfNeeded()
            }
        default: return
        }
        currentWelcomeIndex += 1
    }

}

