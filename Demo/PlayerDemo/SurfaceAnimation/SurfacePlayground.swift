import OVKit
import OVKitUIComponents
import UIKit

extension CALayer {
    func ov_demo_previousKey(forKey key: String) -> String {
        "ov.\(key).previous"
    }

    func ov_demo_actualKey(forKey key: String) -> String {
        "ov.\(key).actual"
    }
}

class CheckerboardColor {
    var squareSize: CGFloat = 60

    var lightColor: UIColor = .white

    var darkColor: UIColor = .gray

    var cgColor: CGColor {
        make(squareSize: squareSize, lightColor: lightColor, darkColor: darkColor)
    }

    private func make(squareSize: CGFloat, lightColor: UIColor = .white, darkColor: UIColor = .gray) -> CGColor {
        let patternSize = squareSize * 2
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: patternSize, height: patternSize))

        let patternImage = renderer.image { context in
            let ctx = context.cgContext

            // Light squares
            ctx.setFillColor(lightColor.cgColor)
            ctx.fill(CGRect(x: 0, y: 0, width: patternSize, height: patternSize))

            // Dark squares
            ctx.setFillColor(darkColor.cgColor)
            ctx.fill(CGRect(x: 0, y: 0, width: squareSize, height: squareSize))
            ctx.fill(CGRect(x: squareSize, y: squareSize, width: squareSize, height: squareSize))
        }

        return UIColor(patternImage: patternImage).cgColor
    }
}

class CheckerboardLayer: CALayer {

    override init() {
        super.init()
        self.bounds = .init(origin: .zero, size: .init(width: 1920, height: 1080))
        self.opacity = 0.5
        self.backgroundColor = CheckerboardColor().cgColor
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setValue(_ value: Any?, forKeyPath keyPath: String) {
        if let number = value as? NSNumber {
            print("number: \(number)")
            if number.floatValue > 0.1, number.floatValue < 0.3 {
                print("something strange")
            }
        }
        if Self.storedKeyPaths.contains(keyPath) {
            let valueOld = self.value(forKeyPath: keyPath)
            print("debugggg 1 setValue: \(String(describing: valueOld)) forKeyPath: \(self.ov_demo_previousKey(forKey: keyPath))")
            self.setValue(valueOld, forKey: self.ov_demo_previousKey(forKey: keyPath))
        }
        print("debugggg 1 setValue: \(String(describing: value)) forKeyPath: \(keyPath)")
        self.setValue(value, forKey: self.ov_demo_actualKey(forKey: keyPath))
        super.setValue(value, forKeyPath: keyPath)
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("debugggg 2 setValue: \(String(describing: value)) forUndefinedKey: \(key)")
        super.setValue(value, forUndefinedKey: key)
    }

    override func setValue(_ value: Any?, forKey key: String) {
        print("debugggg 3 setValue: \(String(describing: value)) forKey: \(key)")
        super.setValue(value, forKey: key)
    }

    static var storedKeyPaths: [String] = [
        "transform.scale.x",
        "transform.scale.y",
        "transform.translation"
    ]

    override func add(_ anim: CAAnimation, forKey key: String?) {
        let k = _uniqueKey(forKey: key)
        super.add(anim, forKey: k)
    }

    func _uniqueKey(forKey key: String?) -> String? {
        guard let key else {
            return nil
        }

        if !key.hasPrefix("transform.") {
            return key
        }

        guard let animationKeys = animationKeys() else {
            return key
        }

        // Filter and extract indices from indexed variants (including base key as index 1)
        var indices: [Int] = []
        for existingKey in animationKeys {
            if existingKey.hasPrefix(key) {
                let suffix = String(existingKey.dropFirst(key.count))
                // Check if it matches pattern "-N"
                if suffix.hasPrefix("-") && suffix.count > 1 {
                    let indexStr = String(suffix.dropFirst())
                    if let index = Int(indexStr), index > 0 && indexStr == String(index) {
                        indices.append(index)
                    }
                }
            }
        }

        // Include base key as index 1 if it exists
        if animationKeys.contains(key) {
            indices.append(1)
        }

        // If no collisions found, return base key
        if indices.isEmpty {
            return key
        }

        // Sort and get the highest index
        indices.sort()
        let maxIndex = indices.last!

        // Return key with next monotonically increasing index
        return "\(key)-\(maxIndex + 1)"
    }
}

// Перенести в VideoPlayerDemo
class SurfacePlayground: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let dimension = 100
        let controls = ControlsView()
        #if OLD_ADS_OFF
        let player = OVKit.PlayerView(frame: .init(x: 0, y: 0, width: dimension, height: dimension), gravity: .fill, controls: controls)
        #else
        let player = OVKit.PlayerView(frame: .init(x: 0, y: 0, width: dimension, height: dimension), gravity: .fill, customControls: controls)
        #endif
        playerView = player
        playerView.isHidden = false
        playerView.layer.borderColor = UIColor.blue.cgColor
        playerView.layer.borderWidth = 1 / UIScreen.main.scale

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let contentModeSegmentedControl = UISegmentedControl(items: ["Fit", "Fill"])
    private let aspectRatioSegmentedControl = UISegmentedControl(items: ["16:9", "5:4", "1:1", "4:5", "9:16"])
    private let presetSegmentedControl = UISegmentedControl(items: ["4:5 Fill", "9:16 Fit"])
    private let viewSizeMultiplierSegmentedControl = UISegmentedControl(items: ["1.0×", "1.5×", "2.0×", "2.5×", "3.0×"])
    private let scaleMultiplierSlider = UISlider()
    private let scaleMultiplierLabel = UILabel()
    private let resetButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    private let animationsSwitch = UISwitch()
    private let animationsLabel = UILabel()
    private let springSwitch = UISwitch()
    private let springLabel = UILabel()
    private let viewSwitchSegmentedControl = UISegmentedControl(items: ["Player", "Custom"])
    private let playButton = UIButton(type: .system)
    private let stopButton = UIButton(type: .system)
    private let animationDurationSlider = UISlider()
    private let animationDurationLabel = UILabel()
    private var playerView: PlayerView

    private var aspectRatio: CGFloat = 16.0 / 9.0 {
        didSet {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    private var animationsEnabled: Bool = true
    private var springEnabled: Bool = true
    private var autoplayEnabled: Bool = false {
        didSet {
            if autoplayEnabled {
                self.playerView.play(userInitiated: true)
            } else {
                self.loadVideo()
            }
        }
    }

    private var animationDuration: TimeInterval = 4.0 {
        didSet {
            settingsButton.menu = createSettingsMenu()
        }
    }

    private var currentContentMode: UIView.ContentMode = .scaleAspectFill {
        didSet {
            self.playerView.updateGravity(currentContentMode == .scaleAspectFit ? .fit : .fill, animated: true)
            // Deselect preset control when manually changing content mode
            presetSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        }
    }

    private var contentLayerOrientation: ContentLayerOrientation = .horizontal {
        didSet {
            reloadVideo()
        }
    }

    private var viewSizeMultiplier: CGFloat = 1.5 {
        didSet {
            view.setNeedsLayout()
        }
    }

    private let durationOptions: [TimeInterval] = [0.25, 0.3, 0.5, 1.0, 3.0]
    private let viewSizeMultiplierOptions: [CGFloat] = [1.0, 1.5, 2.0, 2.5, 3.0]

    private enum ContentLayerOrientation {
        /// 1920x1080
        case horizontal
        /// 1080x1920
        case vertical
        /// 1080x1080
        case square

        var size: CGSize {
            switch self {
            case .horizontal:
                return CGSize(width: 1920, height: 1080)
            case .vertical:
                return CGSize(width: 1080, height: 1920)
            case .square:
                return CGSize(width: 1080, height: 1080)
            }
        }

        var title: String {
            switch self {
            case .horizontal:
                return "1920×1080"
            case .vertical:
                return "1080×1920"
            case .square:
                return "1080×1080"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewSwitchSegmentedControl.selectedSegmentIndex = 0
        viewSwitchSegmentedControl.addTarget(self, action: #selector(viewSwitchSegmentedControlValueChanged(_:)), for: .valueChanged)

        contentModeSegmentedControl.selectedSegmentIndex = currentContentMode == .scaleAspectFit ? 0 : 1
        contentModeSegmentedControl.addTarget(self, action: #selector(contentModeSegmentedControlValueChanged(_:)), for: .valueChanged)

        aspectRatioSegmentedControl.selectedSegmentIndex = 0
        aspectRatioSegmentedControl.addTarget(self, action: #selector(aspectRatioSegmentedControlValueChanged(_:)), for: .valueChanged)

        presetSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        presetSegmentedControl.addTarget(self, action: #selector(presetSegmentedControlValueChanged(_:)), for: .valueChanged)
        updatePresetTitles()

        viewSizeMultiplierSegmentedControl.selectedSegmentIndex = 1 // 1.5×
        viewSizeMultiplierSegmentedControl.addTarget(self, action: #selector(viewSizeMultiplierSegmentedControlValueChanged(_:)), for: .valueChanged)

        scaleMultiplierSlider.minimumValue = 0.9
        scaleMultiplierSlider.maximumValue = 4.0
        scaleMultiplierSlider.value = 1.0
        scaleMultiplierSlider.addTarget(self, action: #selector(scaleMultiplierSliderValueChanged(_:)), for: .valueChanged)

        scaleMultiplierLabel.text = "0.90"
        scaleMultiplierLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        scaleMultiplierLabel.textAlignment = .center

        resetButton.setTitle("×", for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        resetButton.addTarget(self, action: #selector(resetButtonTapped(_:)), for: .touchUpInside)

        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.menu = createSettingsMenu()
        settingsButton.showsMenuAsPrimaryAction = true

        animationsLabel.text = "Animations"
        animationsLabel.font = .systemFont(ofSize: 14, weight: .regular)
        animationsSwitch.isOn = animationsEnabled
        animationsSwitch.addTarget(self, action: #selector(animationsSwitchValueChanged(_:)), for: .valueChanged)

        springLabel.text = "Spring"
        springLabel.font = .systemFont(ofSize: 14, weight: .regular)
        springSwitch.isOn = springEnabled
        springSwitch.addTarget(self, action: #selector(springSwitchValueChanged(_:)), for: .valueChanged)

        playButton.setTitle("Play", for: .normal)
        playButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)

        stopButton.setTitle("Stop", for: .normal)
        stopButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        stopButton.addTarget(self, action: #selector(stopButtonTapped(_:)), for: .touchUpInside)

        animationDurationSlider.minimumValue = 0.1
        animationDurationSlider.maximumValue = 4.0
        animationDurationSlider.value = Float(animationDuration)
        animationDurationSlider.addTarget(self, action: #selector(animationDurationSliderValueChanged(_:)), for: .valueChanged)

        animationDurationLabel.text = String(format: "%.2f", animationDuration)
        animationDurationLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        animationDurationLabel.textAlignment = .center

        self.view.addSubview(viewSwitchSegmentedControl)
        self.view.addSubview(contentModeSegmentedControl)
        self.view.addSubview(aspectRatioSegmentedControl)
        self.view.addSubview(presetSegmentedControl)
        self.view.addSubview(viewSizeMultiplierSegmentedControl)
        self.view.addSubview(scaleMultiplierSlider)
        self.view.addSubview(scaleMultiplierLabel)
        self.view.addSubview(resetButton)
        self.view.addSubview(settingsButton)
        self.view.addSubview(animationsLabel)
        self.view.addSubview(animationsSwitch)
        self.view.addSubview(springLabel)
        self.view.addSubview(springSwitch)
        self.view.addSubview(playButton)
        self.view.addSubview(stopButton)
        self.view.addSubview(animationDurationSlider)
        self.view.addSubview(animationDurationLabel)
        self.view.insertSubview(playerView, at: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadVideoIfNeeded()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // Layout segmented controls
        let leftMargin = self.view.layoutMargins.left
        let rightMargin = self.view.layoutMargins.right
        let controlWidth = self.view.bounds.width - leftMargin - rightMargin
        let controlHeight = contentModeSegmentedControl.sizeThatFits(.zero).height
        let spacing: CGFloat = 8

        viewSwitchSegmentedControl.frame = CGRect(
            x: leftMargin,
            y: self.view.safeAreaInsets.top,
            width: controlWidth,
            height: controlHeight
        )

        contentModeSegmentedControl.frame = CGRect(
            x: leftMargin,
            y: viewSwitchSegmentedControl.frame.maxY + spacing,
            width: controlWidth,
            height: controlHeight
        )

        aspectRatioSegmentedControl.frame = CGRect(
            x: leftMargin,
            y: contentModeSegmentedControl.frame.maxY + spacing,
            width: controlWidth,
            height: controlHeight
        )

        presetSegmentedControl.frame = CGRect(
            x: leftMargin,
            y: aspectRatioSegmentedControl.frame.maxY + spacing,
            width: controlWidth,
            height: controlHeight
        )

        viewSizeMultiplierSegmentedControl.frame = CGRect(
            x: leftMargin,
            y: presetSegmentedControl.frame.maxY + spacing,
            width: controlWidth,
            height: controlHeight
        )

        // Layout slider row
        let sliderY = viewSizeMultiplierSegmentedControl.frame.maxY + spacing
        let labelWidth: CGFloat = 44
        let buttonWidth: CGFloat = 44

        scaleMultiplierLabel.frame = CGRect(
            x: leftMargin,
            y: sliderY,
            width: labelWidth,
            height: 31
        )

        resetButton.frame = CGRect(
            x: self.view.bounds.width - rightMargin - buttonWidth,
            y: sliderY,
            width: buttonWidth,
            height: 31
        )

        scaleMultiplierSlider.frame = CGRect(
            x: scaleMultiplierLabel.frame.maxX + spacing,
            y: sliderY,
            width: resetButton.frame.minX - scaleMultiplierLabel.frame.maxX - spacing,
            height: 31
        )

        // Layout switch row with settings button
        let switchY = scaleMultiplierSlider.frame.maxY + spacing
        animationsSwitch.sizeToFit()
        springSwitch.sizeToFit()
        let settingsButtonSize: CGFloat = 44

        animationsLabel.frame = CGRect(
            x: leftMargin,
            y: switchY,
            width: animationsLabel.intrinsicContentSize.width,
            height: 31
        )
        animationsSwitch.frame = CGRect(
            x: animationsLabel.frame.maxX + spacing,
            y: switchY,
            width: animationsSwitch.frame.width,
            height: 31
        )

        springLabel.frame = CGRect(
            x: animationsSwitch.frame.maxX + spacing * 2,
            y: switchY,
            width: springLabel.intrinsicContentSize.width,
            height: 31
        )
        springSwitch.frame = CGRect(
            x: springLabel.frame.maxX + spacing,
            y: switchY,
            width: springSwitch.frame.width,
            height: 31
        )

        settingsButton.frame = CGRect(
            x: self.view.bounds.width - rightMargin - settingsButtonSize,
            y: switchY,
            width: settingsButtonSize,
            height: 31
        )

        for subview in [playerView] {
            let baseSize: CGFloat = viewSizeMultiplier * 192

            let size = CGSize(width: baseSize, height: baseSize / aspectRatio)

            subview.frame = .init(
                origin: .init(
                    x: self.view.bounds.midX - size.width / 2,
                    y: self.view.bounds.midY - size.height / 2 + 100
                ),
                size: size
            )
        }

        let playerButtonWidth: CGFloat = 80
        let playerButtonHeight: CGFloat = 44
        let playerButtonSpacing: CGFloat = 20
        let playerButtonsY = self.view.bounds.height - self.view.safeAreaInsets.bottom - playerButtonHeight - playerButtonSpacing

        let durationSliderY = playerButtonsY - 31 - spacing

        animationDurationLabel.frame = CGRect(
            x: leftMargin,
            y: durationSliderY,
            width: labelWidth,
            height: 31
        )

        animationDurationSlider.frame = CGRect(
            x: animationDurationLabel.frame.maxX + spacing,
            y: durationSliderY,
            width: controlWidth - labelWidth - spacing,
            height: 31
        )

        playButton.frame = CGRect(
            x: self.view.bounds.midX - playerButtonWidth - playerButtonSpacing / 2,
            y: playerButtonsY,
            width: playerButtonWidth,
            height: playerButtonHeight
        )

        stopButton.frame = CGRect(
            x: self.view.bounds.midX + playerButtonSpacing / 2,
            y: playerButtonsY,
            width: playerButtonWidth,
            height: playerButtonHeight
        )
    }

    private func createSettingsMenu() -> UIMenu {
        let durationActions = durationOptions.map { duration in
            UIAction(
                title: String(format: "%.2f", duration),
                state: animationDuration == duration ? .on : .off
            ) { [weak self] _ in
                self?.animationDuration = duration
                self?.animationDurationSlider.value = Float(duration)
                self?.animationDurationLabel.text = String(format: "%.2f", duration)
                self?.settingsButton.menu = self?.createSettingsMenu()
            }
        }

        let durationMenu = UIMenu(
            title: "Duration",
            options: .displayInline,
            children: durationActions
        )

        let orientationActions: [UIAction] = [
            UIAction(
                title: ContentLayerOrientation.horizontal.title,
                state: contentLayerOrientation == .horizontal ? .on : .off
            ) { [weak self] _ in
                self?.setContentLayerOrientation(.horizontal)
            },
            UIAction(
                title: ContentLayerOrientation.vertical.title,
                state: contentLayerOrientation == .vertical ? .on : .off
            ) { [weak self] _ in
                self?.setContentLayerOrientation(.vertical)
            },
            UIAction(
                title: ContentLayerOrientation.square.title,
                state: contentLayerOrientation == .square ? .on : .off
            ) { [weak self] _ in
                self?.setContentLayerOrientation(.square)
            }
        ]

        let orientationMenu = UIMenu(
            title: "Content Layer",
            options: .displayInline,
            children: orientationActions
        )

        let autoplayAction = UIAction(
            title: "Autoplay: \(autoplayEnabled ? "ON" : "OFF")",
            state: autoplayEnabled ? .on : .off
        ) { [weak self] _ in
            self?.autoplayEnabled.toggle()
            self?.settingsButton.menu = self?.createSettingsMenu()
        }

        let oldScreen = UIAction(
            title: "Show old screen"
        ) { [weak self] _ in
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 500_000_000)
                self?.showOldLayoutScreen()
            }
        }

        return UIMenu(children: [durationMenu, orientationMenu, autoplayAction, oldScreen])
    }

    private func updatePresetTitles() {
        switch contentLayerOrientation {
        case .horizontal,
             .square:
            presetSegmentedControl.setTitle("16:9 Fill", forSegmentAt: 0)
        case .vertical:
            presetSegmentedControl.setTitle("4:5 Fill", forSegmentAt: 0)
        }
    }

    private func setContentLayerOrientation(_ orientation: ContentLayerOrientation) {
        contentLayerOrientation = orientation
        updatePresetTitles()
        settingsButton.menu = createSettingsMenu()
    }

    @objc
    private func viewSwitchSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        let showPlayer = sender.selectedSegmentIndex == 0

        performAnimated {
            self.playerView.isHidden = !showPlayer
            self.loadVideoIfNeeded()
        }
    }

    @objc
    private func contentModeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        performAnimated {
            self.currentContentMode = sender.selectedSegmentIndex == 0 ? .scaleAspectFit : .scaleAspectFill
        }
    }

    @objc
    private func aspectRatioSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        let newAspectRatio: CGFloat
        switch sender.selectedSegmentIndex {
        case 0:
            newAspectRatio = 16.0 / 9.0
        case 1:
            newAspectRatio = 5.0 / 4.0
        case 2:
            newAspectRatio = 1.0
        case 3:
            newAspectRatio = 4.0 / 5.0
        case 4:
            newAspectRatio = 9.0 / 16.0
        default:
            return
        }

        performAnimated {
            self.aspectRatio = newAspectRatio
        }

        // Deselect preset control when manually changing aspect ratio
        presetSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
    }

    @objc
    private func presetSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // Fill (Feed)
            performAnimated {
                self.playerView.updateGravity(.fill, animated: true)
                switch self.contentLayerOrientation {
                case .horizontal:
                    self.aspectRatio = 16.0 / 9.0
                case .vertical,
                     .square:
                    self.aspectRatio = 4.0 / 5.0
                }
            }
            contentModeSegmentedControl.selectedSegmentIndex = 1 // Fill
            switch contentLayerOrientation {
            case .horizontal:
                aspectRatioSegmentedControl.selectedSegmentIndex = 0 // 16:9
            case .vertical,
                 .square:
                aspectRatioSegmentedControl.selectedSegmentIndex = 3 // 4:5
            }
        case 1:
            // 9:16 Fit (Fullscreen)
            performAnimated {
                self.playerView.updateGravity(.fit, animated: true)
                self.aspectRatio = 9.0 / 16.0
            }
            contentModeSegmentedControl.selectedSegmentIndex = 0 // Fit
            aspectRatioSegmentedControl.selectedSegmentIndex = 4 // 9:16
        default:
            break
        }
    }

    @objc
    private func viewSizeMultiplierSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard sender.selectedSegmentIndex >= 0 && sender.selectedSegmentIndex < viewSizeMultiplierOptions.count else { return }

        let newMultiplier = viewSizeMultiplierOptions[sender.selectedSegmentIndex]

        performAnimated {
            self.viewSizeMultiplier = newMultiplier
            self.view.layoutIfNeeded()
        }
    }

    @objc
    private func scaleMultiplierSliderValueChanged(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        SurfaceAnimate.noAnimations {
            self.playerView.controlsView.controlsContainer?.affineTransform = if value > 1.0 {
                CGAffineTransform(scaleX: value, y: value)
            } else {
                nil
            }
        }
        self.scaleMultiplierLabel.text = String(format: "%.2f", value)
    }

    @objc
    private func resetButtonTapped(_ sender: UIButton) {
        performAnimated {
            self.playerView.controlsView.controlsContainer?.affineTransform = nil
        }
        self.scaleMultiplierSlider.value = 1.0
        self.scaleMultiplierLabel.text = "1.00"
    }

    @objc
    private func animationsSwitchValueChanged(_ sender: UISwitch) {
        animationsEnabled = sender.isOn
    }

    @objc
    private func springSwitchValueChanged(_ sender: UISwitch) {
        springEnabled = sender.isOn
    }

    @objc
    private func playButtonTapped(_ sender: UIButton) {
        self.playerView.play(userInitiated: true)
    }

    @objc
    private func stopButtonTapped(_ sender: UIButton) {
        self.playerView.stop()
    }

    @objc
    private func animationDurationSliderValueChanged(_ sender: UISlider) {
        let value = TimeInterval(sender.value)
        animationDuration = value
        self.animationDurationLabel.text = String(format: "%.2f", value)
    }

    private func performAnimated(animations: @escaping () -> Void) {
        if animationsEnabled {
            if springEnabled {
                SurfaceAnimate.spring(
                    duration: animationDuration,
                    damping: 1.0,
                    options: [.beginFromCurrentState],
                    animations: animations
                )
            } else {
                SurfaceAnimate.snappy(
                    duration: animationDuration,
                    options: [.curveEaseInOut, .beginFromCurrentState],
                    animations: animations
                )
            }
        } else {
            SurfaceAnimate.noAnimations(animations)
        }
    }

    /// ID of square clip or video to simulate video message
    private var videoId: String {
        switch contentLayerOrientation {
        case .horizontal:
            "1265333_456247417"
        case .vertical:
            "1265333_456247418"
        case .square:
            "1265333_456247407"
        }
    }
}

extension SurfacePlayground {

    var isPlayerShown: Bool {
        viewSwitchSegmentedControl.selectedSegmentIndex == 0
    }

    func showOldLayoutScreen() {
        let vc = SurfaceAnimationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func loadVideoIfNeeded() {
        guard playerView.video == nil else {
            return
        }

        reloadVideo()
    }

    func reloadVideo() {
        guard isPlayerShown else {
            return
        }

        loadVideo()
    }

    private func loadVideo() {
        ApiSession.shared?.fetch(videoIds: [videoId]) { [weak self] videos, error in
            DispatchQueue.main.async {
                guard let self else {
                    return
                }
                guard error == nil else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                guard let video = videos?.first else {
                    print("Can't find video")
                    return
                }

                let player = self.playerView
                player.video = video
                video.repeated = true
                let mode: PlayerViewGravity = switch self.presetSegmentedControl.selectedSegmentIndex {
                case 0:
                    .fill
                case 1:
                    .fit
                default:
                    self.currentContentMode == .scaleAspectFit ? .fit : .fill
                }
                player.updateGravity(mode, animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak player] in
                    guard let player else {
                        return
                    }

                    if self.autoplayEnabled {
                        player.play(userInitiated: true)
                    }
                }
            }
        }
    }
}

private final class ControlsView: UIView, PlayerControlsViewProtocol {
    weak var controlsContainer: (OVKit.ControlsViewContainer)?

    weak var controlsDelegate: OVKit.ControlsViewDelegate?

    var controlMask: OVKit.ControlMask? {
        didSet {
            guard let mask = controlMask else {
                subtitlesView = nil
                externalPlaybackPlaceholderView = nil
                return
            }

            updateExternalPlaybackPlaceholderView(mask: mask)
            updateSubtitleView(mask: mask)
        }
    }

    var tapGesture: UITapGestureRecognizer? {
        nil
    }

    var hoverGesture: UIGestureRecognizer? {
        nil
    }

    var controlsVisible: Bool { false }

    var autohideMode: OVKit.HideableControlsMode { .never }

    var shouldBeHiddenInitially: Bool { true }

    var shouldBeHiddenDuringTransition: Bool { true }

    var hidingEnabled: Bool { true }

    private var subtitlesView: SubtitlesView? {
        willSet {
            subtitlesView?.removeFromSuperview()
        }
        didSet {
            if let subtitlesView = subtitlesView {
                insertSubview(subtitlesView, at: 0)
            }
        }
    }

    private var externalPlaybackPlaceholderView: UIView? {
        willSet {
            externalPlaybackPlaceholderView?.removeFromSuperview()
        }
        didSet {
            if let view = externalPlaybackPlaceholderView {
                addSubview(view)
            }
        }
    }

    init() {
        super.init(frame: .zero)

        self.makeSubtitlesViewIfNeeded()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutExternalPlaybackPlaceholderView()

        if let subtitlesView {
            subtitlesView.maxAvailableFrame = availableFrameForSubtitles()
        }
    }

    func handleSubtitlesCaptionUpdate() {
        guard let subtitlesView = subtitlesView else { return }
        guard
            let mask = controlMask,
            mask.hasControl(.sparked),
            !mask.hasControl(.gif),
            mask.screencastState == nil,
            let caption = mask.getControl(.caption),
            case let .caption(text, fullText) = caption
        else {
            subtitlesView.update(text: nil, fullText: nil)
            return
        }

        subtitlesView.update(text: text, fullText: fullText)
    }

    func handlePlayerTick() {}

    func prepareForReuse() {}

    func didUpdatePreview(_ preview: UIImage?) {}

    func didUpdateGravity() {}

    func hideControls(animated: Bool) {}

    func showControls(animated: Bool) {}

    // MARK: - External playback placeholder

    private func updateExternalPlaybackPlaceholderView(mask: ControlMask) {
        guard mask.screencastState != nil else {
            externalPlaybackPlaceholderView = nil
            return
        }

        if externalPlaybackPlaceholderView == nil {
            let placeholder = UIView()
            externalPlaybackPlaceholderView = placeholder
        }

        layoutExternalPlaybackPlaceholderView()
    }

    private func layoutExternalPlaybackPlaceholderView() {
        guard let view = externalPlaybackPlaceholderView else { return }

        view.frame = CGRect(origin: .zero, size: bounds.size)
    }

    // MARK: - Subtitle

    private func updateSubtitleView(mask: ControlMask) {
        if let info = mask.subtitlesInfo {
            makeSubtitlesViewIfNeeded()
            subtitlesView?.isAutoSubtitles = info.isAutoSubtitles
            handleSubtitlesCaptionUpdate()
        } else {
            subtitlesView = nil
        }
    }

    private func makeSubtitlesViewIfNeeded() {
        guard subtitlesView == nil else { return }

        let view = SubtitlesView()
        view.topAlignment = false
        view.fontSize = 15
        view.maxAvailableFrame = availableFrameForSubtitles()
        subtitlesView = view
    }

    private func availableFrameForSubtitles() -> CGRect {
        let maxWidth = bounds.width - 48 * 2 - 8 * 2
        let maxHeight = bounds.height - 8 * 2
        if maxHeight < 40 || maxWidth < 100 { return .zero }
        return CGRect(x: 48 + 8, y: 8, width: maxWidth, height: maxHeight)
    }
}
