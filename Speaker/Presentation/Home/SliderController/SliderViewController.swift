import UIKit

final class SliderViewController: SpeakerViewController {

    enum SliderMode {
        case volume
        case bass
        case treble
    }

    private let currentMode: SliderMode

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.bold, size: 22)
        label.numberOfLines = 1
        label.text = switch currentMode {
        case .volume: "Volume"
        case .bass: "Bass"
        case .treble: "Treble"
        }
        return label
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(.sliderPlus, for: .normal)
        button.setImage(.sliderPlus, for: .highlighted)
        button.addTarget(self, action: #selector(tapPlus), for: .touchUpInside)

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longPress.minimumPressDuration = 1.5
        button.addGestureRecognizer(longPress)
        return button
    }()

    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(.sliderMinus, for: .normal)
        button.setImage(.sliderMinus, for: .highlighted)
        button.addTarget(self, action: #selector(tapMinus), for: .touchUpInside)
        return button
    }()

    private lazy var sliderView: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        slider.setThumbImage(.sliderThumb, for: .normal)
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .sliderGray
        slider.addTarget(self, action: #selector(valueChange), for: .valueChanged)
        return slider
    }()

    // MARK: - Init
    init(mode: SliderMode) {
        currentMode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hidePlayer(true)
        setTap()
        view.backgroundColor = .black.withAlphaComponent(0.85)

        view.addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(minusButton)
        backView.addSubview(plusButton)
        backView.addSubview(sliderView)

        backView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(114)
        })

        titleLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(18)
        })

        minusButton.snp.makeConstraints({
            $0.size.equalTo(25)
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(56)
        })

        plusButton.snp.makeConstraints({
            $0.size.equalTo(25)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalToSuperview().offset(56)
        })

        sliderView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(46)
            $0.centerY.equalTo(plusButton.snp.centerY)
        })
    }
}

private extension SliderViewController {

    func setTap() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapBack))
        view.addGestureRecognizer(tap)
    }

    @objc func tapBack() {
        self.dismiss(animated: false)
    }

    @objc func valueChange(sender: UISlider?) {
        print(sender?.value)
    }

    @objc func tapPlus() {
        sliderView.value += 1
    }

    @objc func tapMinus() {
        sliderView.value -= 1
    }

    //TODO: - сделать через таймер изменение значения при long tap
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            print("Long Press")
        }

        if gesture.state == UIGestureRecognizer.State.ended {
            print("Ended")
            sliderView.value += 1
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SliderViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.plusButton) == true ||
            touch.view?.isDescendant(of: self.minusButton) == true {
            return false
        }
        return true
    }
}
