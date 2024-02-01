import UIKit
import OVKResources
import OVKit

class FullscreenCustomControls: UIView, PlayerFullscreenControlsViewProtocol {
    
    // MARK: - PlayerFullscreenControlsViewProtocol
    
    var enableBottomControls: Bool = true
    
    var splitMode: Bool = false
    
    var alwaysShowSoundButton: Bool = false
    
    var keyboardOverlapsBottomView: Bool = false
    
    var keepVisible: Bool = false
    
    var onVisibilityChange: VoidBlock?
    
    var customSafeInsets: UIEdgeInsets? = nil
    
    var customControlInsets: (() -> UIEdgeInsets)?
    
    var customBottomShadowInset: (() -> CGFloat)?
    
    var customBottomShadowHeight: ((UITraitCollection) -> CGFloat?)?

    var controlsDidLayout: (() -> Void)?

    weak var customViewsContainer: UIView?
    
    var bottomControlsFrame: CGRect {
        .zero
    }
    
    func togglePause() {
        handlePlayPauseButton()
    }
    
    func fastSeekForward() {
    }
    
    func fastSeekBackwards() {
    }
    
    func fastSeekToStart() {
    }
 
    
    // MARK: - ClosableControls
    
    var hideCloseButton: Bool = false {
        didSet {
            guard hideCloseButton != oldValue else { return }
            closeButton?.isHidden = isHidden || hideCloseButton
        }
    }
    
    weak var closeButton: UIButton? {
        didSet {
            closeButton?.isHidden = isHidden || controlMask == nil || hideCloseButton
            closeButton?.alpha = controlsVisible ? 1 : 0
        }
    }

    weak var pipButton: UIButton? {
        didSet {
            pipButton?.isHidden = true
        }
    }
    

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
    
    let autohideMode: HideableControlsMode = .byTimeout
    
    let shouldBeHiddenInitially: Bool = true
    
    let shouldBeHiddenDuringTransition: Bool = true
    
    let hidingEnabled: Bool = true
    
    func hideControls(animated: Bool) {
        updateControlsVisible(visible: false, animated: animated)
    }
    
    func showControls(animated: Bool) {
        updateControlsVisible(visible: true, animated: animated)
    }
    
    
    // MARK: - PlayerControlsViewProtocol
    
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
            }
        }
    }
    
    weak var controlsContainer: ControlsViewContainer?
    
    weak var controlsDelegate: ControlsViewDelegate?
    
    func handlePlayerTick() {}
    
    func handleSubtitlesCaptionUpdate() {}
    
    func prepareForReuse() {}
    
    func didUpdatePreview(_ preview: UIImage?) {}
    
    func didUpdateGravity() {}
    
    
    // MARK: - PlayPause
    
    lazy var playPauseButton: PlayPauseButton = {
        return PlayPauseButton(target: self, action: #selector(Self.handlePlayPauseButton))
    }()
    
    @objc func handlePlayPauseButton() {
        if let pause = controlMask?.getControl(.pause) {
            controlsDelegate?.handleControl(pause)
        }
    }
    
    
    // MARK: - View
    
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
        controlsDidLayout?()
    }
    
    override var isHidden: Bool {
        didSet {
            closeButton?.isHidden = isHidden || hideCloseButton
        }
    }
    
    func updateControlsVisible(visible: Bool, animated: Bool) {
        let alpha: CGFloat = visible ? 1 : 0
        let update = {
            self.playPauseButton.alpha = alpha
            self.closeButton?.alpha = self.splitMode ? 1.0 : alpha
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
