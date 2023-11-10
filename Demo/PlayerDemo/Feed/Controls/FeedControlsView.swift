import UIKit
import OVKit


/// Показывается только badge со статусом воспроизведения и временем до окончания видео. Перемотка и play/pause недоступны.
public class FeedControlsView: UIView, PlayerControlsViewProtocol, LiveSpectatorsControls {
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)

        let indicator = FeedIndicatorView(frame: .zero)
        feedIndicator = indicator
        addSubview(indicator)
        
        if let logoImageView = makeLogoImageView() {
            let size = logoImageView.bounds.width
            topRightContainer.addArrangedSubview(logoImageView)
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            logoImageView.widthAnchor.constraint(equalToConstant: size).isActive = true
            logoImageView.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
        topRightContainer.addArrangedSubview(soundButton)
        if let subtitlesButton = makeSubtitlesButton() {
            topRightContainer.addArrangedSubview(subtitlesButton)
        }
        
        topRightContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topRightContainer)
        topRightContainer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        topRightContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PlayerControlsViewProtocol
    
    weak public var controlsContainer: ControlsViewContainer?
    
    weak public var controlsDelegate: ControlsViewDelegate?
    
    public var controlMask: ControlMask? {
        didSet {
            guard let mask = controlMask else {
                soundButton.isHidden = true
                logoImageView?.isHidden = true
                feedIndicator?.isHidden = true
                liveIndicator?.isHidden = true
                externalPlaybackBadgeView = nil
                subtitlesButton?.isHidden = true
                subtitlesView = nil
                return
            }
            
            isLiveAppearance = mask.hasControl(.live)
            
            let sparked = mask.hasControl(.sparked)
            let isScreencast = mask.screencastState != nil
            let isGIF = mask.hasControl(.gif)
            
            if !isGIF, let sound = mask.getControl(.sound), sparked, case .sound(let enabled, _) = sound, !isScreencast {
                soundButton.appearance = enabled ? .soundOn : .soundOff
                soundButton.isHidden = false
            } else {
                soundButton.isHidden = true
            }
            
            logoImageView?.isHidden = !sparked || isScreencast
            
            updateFeedIndicator(mask: mask)
            updateLiveBadge(mask: mask)
            updateExternalPlaybackBadge(mask: mask)
            
            if let subtitlesButton = subtitlesButton {
                if mask.hasControl(.subtitles), sparked, !isScreencast, !isGIF {
                    subtitlesButton.appearance = mask.subtitlesInfo?.activeLanguageCode != nil ? .active : .inactive
                    subtitlesButton.isHidden = false
                } else {
                    subtitlesButton.isHidden = true
                }
            }
            // создание / удаление view в зависимости выбраны ли субтитры
            if let info = mask.subtitlesInfo {
                makeSubtitlesViewIfNeeded()
                subtitlesView?.isAutoSubtitles = info.isAutoSubtitles
                handleSubtitlesCaptionUpdate()
            } else {
                subtitlesView = nil
            }
        }
    }
    
    
    public func handlePlayerTick() {
        guard feedIndicator != nil else { return }
        guard let playhead = controlMask?.getControl(.playhead),
            case .playhead(let playSeconds) = playhead else {
                return
        }
        
        updateRemainingTime(currentTime: playSeconds)
    }
    
    
    public func handleSubtitlesCaptionUpdate() {
        guard let subtitlesView = subtitlesView else { return }
        guard let mask = controlMask, mask.hasControl(.sparked), !mask.hasControl(.gif), mask.screencastState == nil else {
            subtitlesView.update(text: nil, fullText: nil)
            return
        }
        guard let caption = mask.getControl(.caption), case .caption(let text, let fullText) = caption else {
            subtitlesView.update(text: nil, fullText: nil)
            return
        }
        subtitlesView.update(text: text, fullText: fullText)
    }
    
    
    public func prepareForReuse() {}
    
    
    public func didUpdatePreview(_ preview: UIImage?) {}
    
    
    public func didUpdateGravity() {}
    
    // MARK: - LiveSpectatorsControls
    
    public func handleUpdateSpectators() {
        guard let controlMask else { return }
        updateLiveBadge(mask: controlMask)
    }
    
    
    // MARK: - HideableControls
    
    public var tapGesture: UITapGestureRecognizer? {
        nil
    }
    
    
    public var hoverGesture: UIGestureRecognizer? {
        nil
    }
    
    
    public var controlsVisible: Bool {
        soundButton.alpha == 1.0
    }
    
    
    public var autohideMode: HideableControlsMode {
        .whenNotPlaying
    }
    
    public var shouldBeHiddenInitially: Bool {
        false
    }
    
    public var shouldBeHiddenDuringTransition: Bool {
        true
    }
    
    
    public var hidingEnabled: Bool {
        true
    }
    
    
    public func hideControls(animated: Bool) {
        updateControlsVisible(visible: false, animated: animated)
    }
    
    
    public func showControls(animated: Bool) {
        updateControlsVisible(visible: true, animated: animated)
    }
    
    
    private func updateControlsVisible(visible: Bool, animated: Bool) {
        let alpha: CGFloat = visible ? 1 : 0
        let update = {
            self.soundButton.alpha = alpha
            self.subtitlesButton?.alpha = alpha
            self.logoImageView?.alpha = alpha
        }
        if animated {
            UIView.animate(withDuration: DiscoverControlsView.visibilityAnimationDuration,
                           delay: 0,
                           options: DiscoverControlsView.visibilityAnimationOptions,
                           animations: {
                update()
                self.controlsDelegate?.visibilityDidChangeTo(visible: visible)
            }, completion: nil)
        } else {
            update()
            controlsDelegate?.visibilityDidChangeTo(visible: visible)
        }
    }
    
    
    // MARK: - Private
    
    private var feedIndicator: FeedIndicatorView?

    private var isLiveAppearance = false {
        didSet {
            guard oldValue != isLiveAppearance else { return }
            if isLiveAppearance {
                feedIndicator?.removeFromSuperview()
                feedIndicator = nil
                
                liveIndicator = LiveIndicatorView.makeStandard(origin: CGPoint(x: 12, y: 12))
                addSubview(liveIndicator!)
                if let mask = controlMask { updateLiveBadge(mask: mask) }
            } else {
                liveIndicator?.removeFromSuperview()
                liveIndicator = nil
                
                feedIndicator = FeedIndicatorView(frame: .zero)
                addSubview(feedIndicator!)
                if let mask = controlMask { updateFeedIndicator(mask: mask) }
                layoutFeedIndicator()
            }
        }
    }
    
    private lazy var topRightContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        stackView.semanticContentAttribute = .forceRightToLeft
        return stackView
    }()
    
    
    private lazy var soundButton: SoundButton = {
        let button = SoundButton(target: self, action: #selector(handleSoundButton))
        button.frame.size = CGSize(width: 48, height: 48)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutExternalPlaybackBadge()
        layoutFeedIndicator()
        if let subtitlesView = subtitlesView {
            subtitlesView.fontSize = bounds.width <= 320 ? 13 : 15
            subtitlesView.maxAvailableFrame = availableFrameForSubtitles()
        }
    }
    
    
    // - MARK: - External playback badge
    
    private var externalPlaybackBadgeView: ExternalPlaybackBadgeView? {
        willSet {
            externalPlaybackBadgeView?.removeFromSuperview()
        }
        didSet {
            if let externalPlaybackBadgeView = externalPlaybackBadgeView {
                addSubview(externalPlaybackBadgeView)
            }
        }
    }
    
    
    private func updateExternalPlaybackBadge(mask: ControlMask) {
        guard let screencastState = mask.screencastState, mask.hasControl(.sparked) else {
            externalPlaybackBadgeView = nil
            return
        }
        
        if externalPlaybackBadgeView == nil {
            let badge = ExternalPlaybackBadgeView()
            badge.multiline = true
            externalPlaybackBadgeView = badge
        }
        
        externalPlaybackBadgeView?.apply(screencastState)
        layoutExternalPlaybackBadge()
    }
    
    
    private func layoutExternalPlaybackBadge() {
        guard let badge = externalPlaybackBadgeView else {
            return
        }
        let badgeSize = badge.sizeThatFits(bounds.insetBy(dx: 16, dy: 0).size)
        badge.frame = CGRect(origin: .zero, size: badgeSize)
        badge.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    
    // MARK: - Live badge
    
    private var liveIndicator: LiveIndicatorView?
    
    private func updateLiveBadge(mask: ControlMask) {
        guard let liveIndicator = liveIndicator, liveIndicator.showSpectators else { return }
        
        var spectatorsCount: UInt = 0
        if let live = mask.getControl(.live), case .live(let spectators, _, _) = live {
            spectatorsCount = spectators
        }
        liveIndicator.spectatorsCount = spectatorsCount
    }
    
    
    // MARK: - Feed Indicator
    
    private var videoDuration: TimeInterval = 0
    
    private func updateFeedIndicator(mask: ControlMask) {
        guard let indicator = feedIndicator else { return }
        
        indicator.gifAppearance = mask.hasControl(.gif)
        
        if mask.hasControl(.sparked), !mask.hasControl(.loading), let pause = mask.getControl(.pause), case .pause(false) = pause {
            indicator.state = .playing
        } else if mask.hasControl(.loading) {
            indicator.state = .loading
        } else {
            indicator.state = .idle
        }
        
        if let duration = mask.duration, duration > 0 {
            videoDuration = duration
            
            if let playhead = mask.getControl(.playhead), case .playhead(let playSeconds) = playhead {
                updateRemainingTime(currentTime: playSeconds)
            } else {
                updateRemainingTime(currentTime: 0.0)
            }
            
            indicator.isHidden = false
        } else {
            indicator.isHidden = true
        }
    }
    
    
    private func updateRemainingTime(currentTime: TimeInterval) {
        guard videoDuration >= 0 else {
            return
        }
        let timeRemaining = max(videoDuration - currentTime, 0)
        feedIndicator?.time = timeRemaining
    }
    
    
    private func layoutFeedIndicator() {
        guard let feedIndicator = feedIndicator else { return }
        
        feedIndicator.sizeToFit()
        var feedIndicatorFrame = feedIndicator.frame
        
        let indicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 8.0, right: 8.0)
        feedIndicatorFrame.origin = CGPoint(x: bounds.maxX - feedIndicatorFrame.width - indicatorInsets.right,
                                            y: bounds.maxY - feedIndicatorFrame.height - indicatorInsets.bottom)

        feedIndicator.frame = feedIndicatorFrame
    }
    
    
    // MARK: - Actions
    
    @objc private func handleSoundButton() {
        if let sound = controlMask?.getControl(.sound) {
            controlsDelegate?.handleControl(sound)
        }
    }
    
    
    // MARK: - Subtitles
    
    private var subtitlesButton: StateButton<SubtitlesStateAppearance>?
    
    private var subtitlesView: SubtitlesView? {
        willSet {
            subtitlesView?.removeFromSuperview()
        }
        didSet {
            if let subtitlesView {
                addSubview(subtitlesView)
            }
        }
    }
    
    
    private func makeSubtitlesButton() -> StateButton<SubtitlesStateAppearance>? {
        let frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        let button = StateButton<SubtitlesStateAppearance>(frame: frame, appearance: .inactive)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSubtitlesButton), for: .touchUpInside)
        subtitlesButton = button
        return button
    }
    
    
    @objc private func handleSubtitlesButton() {
        if let subtitles = controlMask?.getControl(.subtitles) {
            controlsDelegate?.handleControl(subtitles)
        }
    }
    
    
    private func makeSubtitlesViewIfNeeded() {
        guard subtitlesView == nil else { return }
        let view = SubtitlesView()
        view.fontSize = bounds.width <= 320 ? 13 : 15
        view.maxAvailableFrame = availableFrameForSubtitles()
        subtitlesView = view
    }
    
    
    private func availableFrameForSubtitles() -> CGRect {
        let minY = topRightContainer.frame.maxY
        var maxY = bounds.height - 16
        var xPadding: CGFloat = 8
        if let feedIndicator = feedIndicator {
            maxY = feedIndicator.frame.maxY
            xPadding = bounds.width - feedIndicator.frame.minX + 8
        }
        let height = maxY - minY
        let width = bounds.width - 2 * xPadding
        if height < 40 || width < 100 { return .zero }
        return CGRect(x: xPadding, y: minY, width: width, height: height)
    }
    

    private var logoImageView: UIImageView?
    

    private func makeLogoImageView() -> UIImageView? {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        imageView.contentMode = .center
        imageView.image = .ovk_vkLogo24
        logoImageView = imageView
        return imageView
    }
}
