import Foundation
import OVKit
import OVKitUIComponents
import OVKResources
import UIKit

class SurfaceAnimationViewController: UIViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .allButUpsideDown
    }

    class PlayerContainerView: UIView {

        let playerView: OVKit.PlayerView

        init(playerView: OVKit.PlayerView) {
            self.playerView = playerView
            super.init(frame: .zero)
            self.addSubview(playerView)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            playerView.center = .init(x: bounds.midX, y: bounds.midY)
            playerView.bounds.size = bounds.size
        }
    }

    // MARK: Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground

        Environment._allowRendererSwitching = true

        setupPlayerViewContainer()
        setupAnimationButtonsStackView()
        setupSettingsButton()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layoutButtons()
        layoutPlayerView()
    }

    // MARK: Subview

    private var playerViewContainer: PlayerContainerView?

    private var animationButtonsStackViewContainer: UIView?

    private var animationButtonsStackView: UIStackView?

    func newPlayerView() -> OVKit.PlayerView {
        let controls = ControlsView()
        let playerView = OVKit.PlayerView(frame: .init(x: 0, y: 0, width: 100, height: 100), gravity: .fit, customControls: controls)
        playerView.soundOn = true
        playerView.backgroundPlaybackPolicy = .continueAudioAndVideo
        playerView.loopBehavior = .always
        playerView.disableFinishedCover = true
        playerView.showsPreviewOnFinish = false
        playerView.customPreviewBackgroundColor = .yellow
        playerView.backgroundColor = .red
        playerView.startButtonBehavior = .init(withAutoplay: .hidden, isActiveWhenAutoplayIsDisabled: true)
        playerView.allowsMultiplay = true
        playerView._prefersCustomRenderer = useMetal
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }

    func setupPlayerViewContainer() {
        playerViewContainer?.removeFromSuperview()
        playerViewContainer = nil

        playerViewContainer = PlayerContainerView(playerView: newPlayerView())

        if let playerViewContainer {
            playerViewContainer.backgroundColor = .brown
            view.insertSubview(playerViewContainer, at: 0)
            playerViewContainer.center = view.center
            playerViewContainer.bounds.size = CGSize(width: 200, height: 200)
            if useRoundCorners {
                playerViewContainer.layer.cornerRadius = 100.0
                playerViewContainer.layer.masksToBounds = true
                playerViewContainer.layer.cornerCurve = .circular
            }
            loadVideo()
        }
    }

    private func setupAnimationButtonsStackView() {
        animationButtonsStackView?.removeFromSuperview()
        animationButtonsStackView = nil

        let spacing = 8.9
        let containerEffect: UIVisualEffect?
        if #available(iOS 26.0, *) {
            let glassContainerEffect = UIGlassContainerEffect()
            glassContainerEffect.spacing = spacing
            containerEffect = glassContainerEffect
        } else {
            containerEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        }
        let containerView = UIVisualEffectView(effect: containerEffect)

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = spacing

        let noAnimationButton = createButton(title: "Force Layout", action: #selector(noAnimation))
        let animateOldButton = createButton(title: "UIView.animate", action: #selector(animateOld))
        let animateNewButton = createButton(title: "Property Animator", action: #selector(animateNew))
        stackView.addArrangedSubview(noAnimationButton)
        stackView.addArrangedSubview(animateOldButton)
        stackView.addArrangedSubview(animateNewButton)

        containerView.contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: containerView.contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: containerView.contentView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: containerView.contentView.bottomAnchor, constant: -12)
        ])

        view.addSubview(containerView)

        animationButtonsStackViewContainer = containerView
        animationButtonsStackView = stackView
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)

        if #available(iOS 26.0, *) {
            var configuration = UIButton.Configuration.glass()
            configuration.title = title
            configuration.baseForegroundColor = .label
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { _ in
                AttributeContainer([
                    .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                ])
            }
            configuration.titleLineBreakMode = .byWordWrapping
            button.configuration = configuration
        } else {
            button.setTitle(title, for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        }
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: action, for: .touchUpInside)

        return button
    }

    private var settingsButton: UIButton?

    private func setupSettingsButton() {
        let button = UIButton(type: .system)
        if #available(iOS 26.0, *) {
            var configuration = UIButton.Configuration.glass()
            configuration.image = UIImage(systemName: "gearshape")
            button.configuration = configuration
        } else {
            button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        }
        button.showsMenuAsPrimaryAction = true
        button.menu = createContextMenu()
        view.addSubview(button)
        settingsButton = button
    }

    // MARK: Network

    private func loadVideo() {
        ApiSession.shared?.fetch(videoIds: [videoId]) { [weak self] videos, error in
            DispatchQueue.main.async {
                guard let self else {
                    return
                }
                guard let playerViewContainer = self.playerViewContainer else {
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

                playerViewContainer.isHidden = false
                playerViewContainer.playerView.video = video

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak playerViewContainer] in
                    guard let playerViewContainer else {
                        return
                    }

                    playerViewContainer.playerView.play(userInitiated: true)
                }
            }
        }
    }

    // MARK: State

    /// ID of square clip or video to simulate video message
    private let videoId = "1265333_456247154"

    private var duration: TimeInterval = 0.5 {
        didSet {
            updateAnimator()
            updateContextMenu()
        }
    }

    /// Используйте, чтобы переключать тип рендерера у PlayerView.
    private var useMetal = false {
        didSet {
            setupPlayerViewContainer()
            layoutPlayerView()
        }
    }

    private var delay: TimeInterval = 0.0 {
        didSet {
            updateContextMenu()
        }
    }

    private var curve = UIView.AnimationCurve.easeInOut {
        didSet {
            updateAnimator()
            updateContextMenu()
        }
    }

    private var useRoundCorners = true {
        didSet {
            setupPlayerViewContainer()
            updateContextMenu()
        }
    }

    private let maxSize = 300.0

    private let minSize = 200.0

    private var isExpanded = false {
        didSet {
            if (self.view.next as? UIViewController) != nil {
                // UIViewController, for demo purpose
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            } else {
                // UIView
                layoutPlayerView()
            }
        }
    }

    private var dimension: CGFloat {
        isExpanded ? minSize : maxSize
    }

    private var radius: CGFloat {
        dimension / 2.0
    }

    private var center: CGPoint {
        .init(
            x: self.view.bounds.maxX - radius - self.view.layoutMargins.right,
            y: self.view.bounds.midY - (isExpanded ? radius : 0.0)
        )
    }

    private lazy var animator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve)
        animator.isInterruptible = true
        return animator
    }()

    private func updateAnimator() {
        if duration < CGFLOAT_EPSILON {
            animator = UIViewPropertyAnimator(duration: CGFLOAT_EPSILON, curve: curve)
        } else {
            animator = UIViewPropertyAnimator(duration: duration, curve: curve)
        }
        animator.isInterruptible = true
    }

    // MARK: Actions

    @objc
    func toggleEnvironment() {
        Environment._surfaceView.toggle()
        setupPlayerViewContainer()
        layoutPlayerView()
        updateContextMenu()
    }

    @objc
    private func animateOld() {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [
                .layoutSubviews,
                .beginFromCurrentState,
                curve.uikitValue,
            ],
            animations: { [weak self] in
                guard let self else {
                    return
                }

                self.togglePlayerSize()
            }
        )
    }

    @objc
    private func animateNew() {
        animator.stopAnimation(true)
        animator.finishAnimation(at: .current)
        animator.addAnimations { [weak self] in
            guard let self else {
                return
            }

            self.togglePlayerSize()
        }
        animator.startAnimation(afterDelay: delay)
    }

    @objc
    private func noAnimation() {
        UIView.performWithoutAnimation {
            togglePlayerSize()
        }
    }

    @objc
    private func togglePlayerSize() {
        isExpanded.toggle()
    }

    // MARK: Layout

    private func layoutButtons() {
        let buttonSize = 44.0
        let safeArea = view.safeAreaInsets
        let margins = view.layoutMargins

        settingsButton?.frame = CGRect(
            x: view.bounds.width - safeArea.right - margins.right - buttonSize,
            y: safeArea.top,
            width: buttonSize,
            height: buttonSize
        )
        layoutButtonsStackView()
    }

    private func layoutButtonsStackView() {
        guard let stackView = animationButtonsStackView,
              let containerView = animationButtonsStackViewContainer else {
            return
        }

        let bounds = view.bounds
        let margins = view.layoutMargins
        let padding = min(margins.left, 16.0)
        let stackSize: CGSize = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let containerHeight: CGFloat = min(44.0, stackSize.height) + 2.0 * padding
        let horizontalPadding: CGFloat = margins.right
        let bottomPadding: CGFloat = margins.bottom
        let containerWidth = min(
            stackSize.width + 2.0 * padding,
            bounds.width - horizontalPadding * 2
        )
        let containerY = view.bounds.height - containerHeight - bottomPadding
        containerView.frame = CGRect(
            x: (bounds.width - containerWidth) / 2.0,
            y: containerY,
            width: containerWidth,
            height: containerHeight
        ).integral
    }

    private func layoutPlayerView() {
        let radius = radius
        let size = CGSize(width: dimension, height: dimension)
        let center = center
        if let playerViewContainer {
            playerViewContainer.center = center
            playerViewContainer.bounds.size = size
            if self.useRoundCorners {
                playerViewContainer.layer.cornerRadius = radius
            }
        }
    }
}

extension SurfaceAnimationViewController {

    // MARK: - Context Menu

    private func updateContextMenu() {
        settingsButton?.menu = createContextMenu()
    }

    private func createContextMenu() -> UIMenu {
        UIMenu(title: "Animation Settings", children: [
            createEnvironmentMenu(),
            createDurationMenu(),
            createDelayMenu(),
            createCurveMenu(),
            createRoundCornersMenu()
        ])
    }

    private func createDurationMenu() -> UIMenu {
        UIMenu.createMenu(
            titlePrefix: "Duration",
            options: [
                (0.0, "0.0s"),
                (0.2, "0.2s"),
                (0.5, "0.5s"),
                (1.0, "1.0s"),
                (3.0, "3.0s")
            ],
            currentValue: duration,
            onSelect: { [weak self] newDuration in
                self?.duration = newDuration
            }
        )
    }

    private func createDelayMenu() -> UIMenu {
        UIMenu.createMenu(
            titlePrefix: "Delay",
            options: [
                (0.0, "OFF"),
                (1.0, "ON")
            ],
            currentValue: delay,
            onSelect: { [weak self] newDelay in
                self?.delay = newDelay
            }
        )
    }

    private func createCurveMenu() -> UIMenu {
        UIMenu.createMenu(
            titlePrefix: "Curve",
            options: [
                (.easeInOut, ".easeInOut"),
                (.linear, ".linear"),
                (.easeIn, ".easeIn"),
                (.easeOut, ".easeOut")
            ],
            currentValue: curve,
            onSelect: { [weak self] newCurve in
                self?.curve = newCurve
            }
        )
    }

    private func createRoundCornersMenu() -> UIMenu {
        UIMenu.createMenu(
            titlePrefix: "Round Corners",
            options: [
                (true, "ON"),
                (false, "OFF")
            ],
            currentValue: useRoundCorners,
            onSelect: { [weak self] newValue in
                self?.useRoundCorners = newValue
            }
        )
    }

    private func createEnvironmentMenu() -> UIMenu {
        UIMenu.createMenu(
            titlePrefix: "Environment",
            options: [
                (true, "ON"),
                (false, "OFF")
            ],
            currentValue: Environment._surfaceView,
            onSelect: { [weak self] _ in
                self?.toggleEnvironment()
            }
        )
    }
}

extension UIMenu {

    static func createActions<T: Equatable>(
        from options: [(T, String)],
        currentValue: T,
        onSelect: @escaping (T) -> Void
    ) -> [UIAction] {
        options.map { value, title in
            UIAction(
                title: title,
                state: currentValue == value ? .on : .off,
                handler: { _ in
                    onSelect(value)
                }
            )
        }
    }

    static func createActions<T: Equatable>(
        from options: [T],
        titles: [String],
        currentValue: T,
        onSelect: @escaping (T) -> Void
    ) -> [UIAction] {
        zip(options, titles).map { value, title in
            UIAction(
                title: title,
                state: currentValue == value ? .on : .off,
                handler: { _ in
                    onSelect(value)
                }
            )
        }
    }

    static func currentTitle<T: Equatable>(from options: [(T, String)], currentValue: T) -> String {
        options.first { $0.0 == currentValue }?.1 ?? "unknown"
    }

    static func createMenu<T: Equatable>(
        titlePrefix: String,
        options: [(T, String)],
        currentValue: T,
        onSelect: @escaping (T) -> Void
    ) -> UIMenu {
        let actions = createActions(from: options, currentValue: currentValue, onSelect: onSelect)
        let currentTitle = "\(titlePrefix): \(currentTitle(from: options, currentValue: currentValue))"
        return UIMenu(title: currentTitle, children: actions)
    }

    static func createMenu<T: Equatable>(
        titlePrefix: String,
        options: [T],
        titles: [String],
        currentValue: T,
        onSelect: @escaping (T) -> Void
    ) -> UIMenu {
        let actions = createActions(from: options, titles: titles, currentValue: currentValue, onSelect: onSelect)
        let currentTitle = "\(titlePrefix): \(titles[options.firstIndex(of: currentValue) ?? 0])"
        return UIMenu(title: currentTitle, children: actions)
    }

    static func createMenuWithReduce<T: Equatable>(
        titlePrefix: String,
        options: [(T, String)],
        currentValue: T,
        onSelect: @escaping (T) -> Void
    ) -> UIMenu {
        let actions = options.reduce(into: [UIAction]()) { result, option in
            let (value, title) = option
            result.append(UIAction(
                title: title,
                state: currentValue == value ? .on : .off,
                handler: { _ in onSelect(value) }
            ))
        }

        let currentTitle = options
            .first { $0.0 == currentValue }?
            .1 ?? "unknown"
        return UIMenu(title: "\(titlePrefix): \(currentTitle)", children: actions)
    }
}

extension UIView.AnimationCurve {
    var uikitValue: UIView.AnimationOptions {
        switch self {
        case .easeInOut:
            return .curveEaseInOut
        case .linear:
            return .curveLinear
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        @unknown default:
            fatalError()
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
