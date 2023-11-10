import UIKit
import OVKit
import OVKResources


class PiPCustomControls: UIView, PlayerPiPControlsViewProtocol {
    
    // MARK: - ClosableControls
    
    weak var closeButton: UIButton?
    
    // Можно скрыть стандартную и нарисовать свою кнопку закрытия PiP
    // Чтобы закрыть PiP своей кнопкой нужно вызвать PlayerManager.shared.closePiP()
    var hideCloseButton: Bool = false
    
    
    // MARK: - PlayerPiPControlsViewProtocol
    
    // Можно скрыть стандартную и нарисовать свою кнопку перехода в fullscreen.
    // Чтобы перейти в fullscreen нужно вызвать controlsDelegate?.handleControl(.fullscreen)
    let hideFullscreenButton: Bool = true
    
    weak var fullscreenButton: UIButton?
    
    
    // MARK: - HideableControls
    
    lazy var tapGesture: UITapGestureRecognizer? = {
        let gesture = UITapGestureRecognizer()
        addGestureRecognizer(gesture)
        return gesture
    }()
    
    
    let hoverGesture: UIGestureRecognizer? = nil
    
    
    var controlsVisible: Bool {
        return playPauseButton.alpha == 1
    }
    
    
    var autohideMode: HideableControlsMode {
        .byTimeout
    }
    
    
    let shouldBeHiddenInitially: Bool = false
    
    
    let shouldBeHiddenDuringTransition: Bool = true
    
    
    let hidingEnabled: Bool = true
    
    
    func hideControls(animated: Bool) {
        updateControlsVisible(visible: false, animated: animated)
    }
    
    
    func showControls(animated: Bool) {
        updateControlsVisible(visible: true, animated: animated)
    }
    
    
    // MARK: - PlayerControlsViewProtocol
    
    weak var controlsContainer: ControlsViewContainer?
    
    
    weak var controlsDelegate: ControlsViewDelegate?
    
    
    var controlMask: ControlMask? {
        didSet {
            guard let mask = controlMask else {
                playPauseButton.isHidden = true
                return
            }
            
            if mask.hasControl(.loading) {
                playPauseButton.isHidden = true
            } else {
                if let pause = mask.getControl(.pause), mask.hasControl(.sparked), case .pause(let paused) = pause {
                    playPauseButton.appearance = paused ? .play : .pause
                    playPauseButton.isHidden = false
                } else {
                    playPauseButton.isHidden = true
                }
                if mask.hasControl(.gif) {
                    playPauseButton.isHidden = true
                }
            }
        }
    }
    
    
    func prepareForReuse() {}
    
    
    func didUpdateGravity() {}
    
    
    func didUpdatePreview(_ preview: UIImage?) {}
    
    
    func handlePlayerTick() {}
    
    
    func handleSubtitlesCaptionUpdate() {}
    
    
    // MARK: - PlayPause
    
    lazy var playPauseButton = PiPPlayPauseButton(target: self, action: #selector(handlePlayPauseButton))
    
    @objc func handlePlayPauseButton() {
        if let pause = controlMask?.getControl(.pause) {
            controlsDelegate?.handleControl(pause)
        }
    }
    
    
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playPauseButton)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playPauseButton.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    
    func updateControlsVisible(visible: Bool, animated: Bool) {
        let alpha: CGFloat = visible ? 1 : 0
        let update = {
            self.playPauseButton.alpha = alpha
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
