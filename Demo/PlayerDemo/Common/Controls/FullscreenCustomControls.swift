//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import OVKResources
import UIKit

class FullscreenCustomControls: UIView, PlayerFullscreenControlsViewProtocol {
    // MARK: - PlayerFullscreenControlsViewProtocol

    var splitMode = false

    var onVisibilityChange: VoidBlock?

    var customSafeInsets: UIEdgeInsets?

    func togglePause() {
        handlePlayPauseButton()
    }

    func fastSeekForward() {}

    func fastSeekBackwards() {}

    func fastSeekToStart() {}

    func keyboardOverlapHeightChanged(to height: CGFloat) {}

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

    let autohideMode = HideableControlsMode.byTimeout

    let shouldBeHiddenInitially = true

    let shouldBeHiddenDuringTransition = true

    let hidingEnabled = true

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
                gravityButton.isHidden = true
                return
            }

            if mask.hasControl(.loading) {
                playPauseButton.isHidden = true
            } else {
                if let pause = mask.getControl(.pause), mask.hasControl(.sparked), case let .pause(paused) = pause {
                    playPauseButton.appearance = paused ? .play : .pause
                    playPauseButton.isHidden = false
                } else {
                    playPauseButton.isHidden = true
                }
            }

            if let gravity = mask.getControl(.gravity),
               case let .gravity(filled) = gravity,
               controlsContainer?.surfaceSize != nil,
               controlsContainer?.videoNaturalSize != nil {
                gravityButton.appearance = filled ? .fit : .fill
                gravityButton.accessibilityIdentifier = filled ? "video_player.gravity_fit_button" : "video_player.gravity_fill_button"
                gravityButton.isHidden = false
            } else {
                gravityButton.isHidden = true
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

    lazy var playPauseButton = PlayPauseButton(target: self, action: #selector(Self.handlePlayPauseButton))

    @objc
    func handlePlayPauseButton() {
        if let pause = controlMask?.getControl(.pause) {
            controlsDelegate?.handleControl(pause)
        }
    }

    // MARK: - Gravity Button

    lazy var gravityButton: GravityControlButton = {
        let button = GravityControlButton(size: 32, target: self, action: #selector(handleGravityButton))
        button.accessibilityIdentifier = "video_player.gravity_fill_button"
        button.accessibilityLabel = "video_player_gravity_button_fill_accessibility_label".ovk_localized()
        button.accessibilityHint = "video_player_gravity_button_fill_accessibility_hint".ovk_localized()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.isHidden = true
        return button
    }()

    @objc
    func handleGravityButton() {
        guard let controlsDelegate,
              let gravity = controlMask?.getControl(.gravity) else {
            return
        }

        controlsDelegate.handleControl(gravity)
    }

    // MARK: - View

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(playPauseButton)
        addSubview(gravityButton)

        gravityButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -18).isActive = true
        gravityButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18).isActive = true
    }

    @available(*, unavailable)
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
            self.gravityButton.alpha = alpha
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
