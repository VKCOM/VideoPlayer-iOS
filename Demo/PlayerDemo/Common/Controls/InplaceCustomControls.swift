import UIKit
import OVKit
import OVKResources


class InplaceCustomControls: UIView, PlayerControlsViewProtocol {
    
    // MARK: - HideableControls
    // Возможность скрывать все или часть UI элементов в контролах по тапу, таймеру,
    // изменениям в процессе воспроизведения или другим настройкам.
    
    
    // Если создать и добавить – позволит по тапу скрывать и показывать контролы через общий механизм автоскрытия.
    lazy var tapGesture: UITapGestureRecognizer? = {
        let gesture = UITapGestureRecognizer()
        addGestureRecognizer(gesture)
        return gesture
    }()
    
    
    // Для iPad и курсора.
    let hoverGesture: UIGestureRecognizer? = nil
    
    
    // Механизм автоскрытия иногда будет спрашивать видны ли UI элементы,
    // чтобы понять нужно ли их скрыть или показать.
    var controlsVisible: Bool {
        return playPauseButton.alpha == 1
    }
    
    
    // Механизм автоскрытия будет смотреть на это свойство перед тем как
    // вызывать методы showControls / hideControls.
    var autohideMode: HideableControlsMode {
        timelineView.isAnyTrackingActive ? .never : .byTimeout 
    }
    
    
    // Будут ли скрыты контролы при начале проигрывания.
    let shouldBeHiddenInitially: Bool = true
    
    
    // Это свойство лучше оставлять true, т.к. контролы для разных PlayerView могут отличаться.
    let shouldBeHiddenDuringTransition: Bool = true
    
    
    // Можно полностью выключить механизм автроскрытия контролов.
    let hidingEnabled: Bool = true
    
    
    // Механизм автоскрытия вызовет, чтобы скрыть все или часть UI элементов.
    func hideControls(animated: Bool) {
        updateControlsVisible(visible: false, animated: animated)
    }
    
    
    func showControls(animated: Bool) {
        updateControlsVisible(visible: true, animated: animated)
    }
    
    
    // MARK: - PlayerControlsViewProtocol
    
    // Устанавливать не нужно, обязательно сделать weak.
    weak var controlsContainer: ControlsViewContainer?
    
    
    // Устанавливать не нужно, обязательно сделать weak.
    weak var controlsDelegate: ControlsViewDelegate?
    
    
    // При любых изменениях в состоянии плеера, в контролы устанавливается новая маска.
    // В маске будут ControlValue, которые описывают состояние плеера.
    var controlMask: ControlMask? {
        didSet {
            guard let mask = controlMask else {
                playPauseButton.isHidden = true
                buttonsContainer.isHidden = true
                topShadow.isHidden = true
                bottomShadow.isHidden = true
                timelineView.isHidden = true
                soundButton.isHidden = true
                subtitlesView = nil
                doubleTapSeek.isEnabled = false
                return
            }
            
            let sparked = mask.hasControl(.sparked)
            
            doubleTapSeek.isEnabled = sparked && mask.fastScrubbingAvailable
             
            buttonsContainer.isHidden = !sparked
            topShadow.isHidden = !sparked
            bottomShadow.isHidden = !sparked
            
            if mask.hasControl(.loading) {
                playPauseButton.isHidden = true
            } else {
                if let pause = mask.getControl(.pause), sparked, case .pause(let paused) = pause {
                    playPauseButton.appearance = paused ? .play : .pause
                    playPauseButton.isHidden = false
                } else {
                    playPauseButton.isHidden = true
                }
            }
            
            let timelineWasHidden = timelineView.isHidden
            timelineView.isLiveAppearance = mask.hasControl(.live)
            if mask.hasControl(.live) {
                if sparked, let rewindValues = mask.liveRewindValues, rewindValues.available > 0 {
                    timelineView.update(progress: rewindValues.available - rewindValues.behind,
                                        duration: rewindValues.available,
                                        preload: 0,
                                        timeCodes: [],
                                        animated: false)
                    timelineView.isHidden = false
                } else {
                    timelineView.isHidden = true
                }
            } else {
                if let timelineValues = mask.timelineValues, timelineValues.duration > 0 {
                    var animated = false
                    if let pause = mask.getControl(.pause), case .pause(let paused) = pause { animated = !paused }
                    timelineView.update(progress: timelineValues.currentTime,
                                        duration: timelineValues.duration,
                                        preload: timelineValues.preload,
                                        timeCodes: mask.timeCodes,
                                        animated: animated)
                    if !timelineView.isAnyTrackingActive {
                        timelineView.updateCurrentTimeCode(mask.chapterProvider?.currentChapter?.time)
                    }
                    timelineView.isHidden = false
                } else {
                    timelineView.isHidden = true
                }
            }
            
            if let sound = mask.getControl(.sound), sparked, case .sound(let enabled, let restricted) = sound, mask.screencastState == nil {
                soundButton.appearance = enabled && !restricted ? .soundOn : .soundOff
                soundButton.isHidden = false
            } else {
                soundButton.isHidden = true
            }
            
            pipButton.isHidden = !mask.hasControl(.pip)
            fullscreenButton.isHidden = !mask.hasControl(.fullscreen)
            
            // создание / удаление view в зависимости выбраны ли субтитры
            if let info = mask.subtitlesInfo {
                makeSubtitlesViewIfNeeded()
                subtitlesView?.isAutoSubtitles = info.isAutoSubtitles
                handleSubtitlesCaptionUpdate()
            } else {
                subtitlesView = nil
            }
            
            screencastButton.isHidden = !mask.hasControl(.screencast)
            let sState = mask.screencastState
            screencastButton.appearance = sState != nil ? .active : .inactive
            
            if timelineWasHidden != timelineView.isHidden {
                setNeedsLayout()
            }
        }
    }
    
    
    // Вызовется при соответствующего метода в PlayerView или установке нового видео
    func prepareForReuse() {}
    
    
    // Сюрфа видео изменилась: fit / fill
    func didUpdateGravity() {}
    
    
    func didUpdatePreview(_ preview: UIImage?) {}
    
    
    // Вызывается во время проигрывания несколько раз в секунду.
    // В этом методе можно вычитать новые значение для таймлайна их текущей ControlMask.
    func handlePlayerTick() {
        guard let mask = controlMask, !mask.hasControl(.live), !timelineView.isHidden else { return }
        
        if let values = mask.timelineValues {
            timelineView.update(progress: values.currentTime, duration: values.duration, preload: values.preload, animated: true)
        }
        if let provider = mask.chapterProvider, !timelineView.isAnyTrackingActive {
            timelineView.updateCurrentTimeCode(provider.currentChapter?.time)
        }
    }
    
    
    // Вызывается при смене текста субтитров или скрытия.
    // Актуальные субтитры нужно брать из текущей ControlMask.
    func handleSubtitlesCaptionUpdate() {
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
    
    
    // MARK: - PlayPause
    
    lazy var playPauseButton: PlayPauseButton = {
        return PlayPauseButton(target: self, action: #selector(Self.handlePlayPauseButton))
    }()
    
    
    @objc func handlePlayPauseButton() {
        if let pause = controlMask?.getControl(.pause) {
            controlsDelegate?.handleControl(pause)
        }
    }
    
    
    // MARK: - Timeline
    
    lazy var timelineView: TimelineView = {
        let view = TimelineView()
        view.isHidden = true
        view.addTarget(self, action: #selector(Self.timelineValueChanged), for: .valueChanged)
        view.addTarget(self, action: #selector(Self.timelineEditingChanged), for: .editingChanged)
        return view
    }()
    
    
    @objc func timelineValueChanged() {
        // пользователь закончил перематывать. TimelineView/currentTime изменилось, нужно сказать плееру перемотать.
        guard let controlsDelegate else { return }
        
        // в сдучае live это будет отставание от реального времени
        let time = timelineView.isLiveAppearance ? timelineView.currentTime - timelineView.durationTime : timelineView.currentTime
        if let provider = controlMask?.chapterProvider {
            timelineView.updateCurrentTimeCode(provider.foundChapterForSeekTime(time)?.time)
        }
        
        controlsDelegate.seekToTime(time, method: .timeline)
    }
    
    
    @objc func timelineEditingChanged() {
        // периодически посылается во время перемотки перетаскиванием
        if let seekTime = timelineView.seekTime, let provider = controlMask?.chapterProvider {
            timelineView.updateCurrentTimeCode(provider.foundChapterForSeekTime(seekTime)?.time)
        }
    }
    
    
    // MARK: - Settings Button
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        button.setImage(.ovk_settings24, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.addTarget(self, action: #selector(Self.handleSettingsButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSettingsButton() {
        controlsDelegate?.presentSettingsMenu()
    }
    
    
    // MARK: - PiP button
    
    lazy var pipButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        button.setImage(.ovk_pipOutline24, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.addTarget(self, action: #selector(Self.handlePiPButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePiPButton() {
        if controlMask?.hasControl(.pip) == true {
            controlsDelegate?.handleControl(.pip)
        }
    }
    
    
    // MARK: - Fullscreen button
    
    lazy var fullscreenButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        button.setImage(.ovk_fullscreen24, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.addTarget(self, action: #selector(Self.handleFullscreenButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleFullscreenButton() {
        if controlMask?.hasControl(.fullscreen) == true {
            controlsDelegate?.handleControl(.fullscreen)
        }
    }
    
    
    // MARK: - Sound button
    
    lazy var soundButton: SoundButton = {
        let button = SoundButton(target: self, action: #selector(Self.handleSoundButton))
        return button
    }()
    
    @objc func handleSoundButton() {
        if let sound = controlMask?.getControl(.sound) {
            controlsDelegate?.handleControl(sound)
        }
    }
    
    
    // MARK: - Subtitles
    
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
    
    func makeSubtitlesViewIfNeeded() {
        guard subtitlesView == nil else { return }
        let view = SubtitlesView()
        view.topAlignment = true
        view.fontSize = 15
        view.maxAvailableFrame = availableFrameForSubtitles()
        subtitlesView = view
    }
    
    func availableFrameForSubtitles() -> CGRect {
        let maxWidth = bounds.width - 48 * 2 - 8 * 2
        let maxHeight = bounds.height - 8 * 2
        if maxHeight < 40 || maxWidth < 100 { return .zero }
        return CGRect(x: 48 + 8, y: 8, width: maxWidth, height: maxHeight)
    }
    
    
    // MARK: - Screencast
    
    private lazy var screencastButton: ScreencastButton = {
        let button = ScreencastButton(target: self, action: #selector(handleScreencastButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        return button
    }()
    
    @objc private func handleScreencastButton() {
        controlsDelegate?.presentScreencastMenu(volumeView: screencastButton.volumeView)
    }
    
    
    // MARK: - Behaviors
    
    lazy var doubleTapSeek = DoubleTapSeekBehavior(shouldBegin: { [weak self] in
        return self?.timelineView.isAnyTrackingActive == false
    })
    
    
    // MARK: - Shadows
    
    lazy var topShadow: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 120))
        imageView.image = .ovk_scrimTop120
        imageView.alpha = 0.48
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var bottomShadow: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 120))
        imageView.image = .ovk_scrimBottom120
        imageView.alpha = 0.48
        imageView.isHidden = true
        return imageView
    }()
    
    
    // MARK: - UIView
    
    lazy var buttonsContainer: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 8
        view.semanticContentAttribute = .forceRightToLeft
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(topShadow)
        addSubview(bottomShadow)
        addSubview(soundButton)
        addSubview(playPauseButton)
        addSubview(timelineView)
        
        buttonsContainer.addArrangedSubview(settingsButton)
        buttonsContainer.addArrangedSubview(pipButton)
        buttonsContainer.addArrangedSubview(fullscreenButton)
        buttonsContainer.addArrangedSubview(screencastButton)
        addSubview(buttonsContainer)
        buttonsContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -18).isActive = true
        buttonsContainer.bottomAnchor.constraint(equalTo: timelineView.topAnchor).isActive = true
        
        addBehavior(doubleTapSeek)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playPauseButton.center = CGPoint(x: bounds.midX, y: bounds.midY)
        timelineView.frame = CGRect(x: 18, y: bounds.height - 36, width: bounds.width - 36, height: 28)
        topShadow.frame = CGRect(x: 0, y: 0, width: bounds.width, height: topShadow.bounds.height)
        bottomShadow.frame = CGRect(x: 0, y: bounds.height - bottomShadow.bounds.height, width: bounds.width, height: bottomShadow.bounds.height)
        soundButton.frame.origin = CGPoint(x: bounds.width - soundButton.bounds.width, y: 0)
        if let subtitlesView {
            subtitlesView.maxAvailableFrame = availableFrameForSubtitles()
        }
    }
    
    
    func updateControlsVisible(visible: Bool, animated: Bool) {
        let alpha: CGFloat = visible ? 1 : 0
        let update = {
            self.playPauseButton.alpha = alpha
            self.timelineView.alpha = alpha
            self.buttonsContainer.alpha = alpha
            self.topShadow.alpha = min(alpha, 0.48)
            self.bottomShadow.alpha = min(alpha, 0.48)
            self.soundButton.alpha = alpha
        }
        if animated {
            UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseInOut, animations: {
                update()
            }) { _ in
                // чтобы отработал метод PlayerViewDelegate/playerControlsVisibilityChanged
                self.controlsDelegate?.visibilityDidChangeTo(visible: visible)
            }
        } else {
            update()
            controlsDelegate?.visibilityDidChangeTo(visible: visible)
        }
    }
}
