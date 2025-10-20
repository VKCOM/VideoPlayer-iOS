//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import OVKResources
import UIKit

class PiPCustomControls: UIView, PlayerControlsViewProtocol {
    // MARK: - HideableControls

    lazy var tapGesture: UITapGestureRecognizer? = {
        let gesture = UITapGestureRecognizer()
        addGestureRecognizer(gesture)
        return gesture
    }()

    let hoverGesture: UIGestureRecognizer? = nil

    var controlsVisible: Bool {
        playPauseButton.alpha == 1
    }

    var autohideMode: HideableControlsMode {
        .byTimeout
    }

    let shouldBeHiddenInitially = false

    let shouldBeHiddenDuringTransition = true

    let hidingEnabled = true

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
                fullscreenButton.isHidden = true
                closeButton.isHidden = true
                return
            }

            fullscreenButton.isHidden = false
            closeButton.isHidden = false

            if mask.hasControl(.loading) {
                playPauseButton.isHidden = true
            } else {
                if let pause = mask.getControl(.pause), mask.hasControl(.sparked), case let .pause(paused) = pause {
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

    @objc
    func handlePlayPauseButton() {
        if let pause = controlMask?.getControl(.pause) {
            controlsDelegate?.handleControl(pause)
        }
    }

    // MARK: - Close

    private lazy var closeButton = ButtonsFactory.pipCloseButton(target: self, action: #selector(handleCloseButton))

    @objc
    private func handleCloseButton() {
        PlayerManager.shared.closePiP()
    }

    // MARK: - Fullscreen

    private lazy var fullscreenButton = ButtonsFactory.pipFullscreenButton(target: self, action: #selector(handleFullscreenButton))

    @objc
    private func handleFullscreenButton() {
        PlayerManager.shared.pipWindow?.maximizeToFullscreen()
    }

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(playPauseButton)
        addSubview(closeButton)
        addSubview(fullscreenButton)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        playPauseButton.center = CGPoint(x: bounds.midX, y: bounds.midY)
        fullscreenButton.center = CGPoint(x: bounds.width - 24, y: 24)
    }

    func updateControlsVisible(visible: Bool, animated: Bool) {
        let alpha: CGFloat = visible ? 1 : 0
        let update = {
            self.playPauseButton.alpha = alpha
            self.closeButton.alpha = alpha
            self.fullscreenButton.alpha = alpha
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
