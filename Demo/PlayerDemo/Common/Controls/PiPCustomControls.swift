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
                seekBackwardButton.isHidden = true
                seekForwardButton.isHidden = true
                return
            }

            fullscreenButton.isHidden = false
            closeButton.isHidden = false
            seekBackwardButton.isHidden = false
            seekForwardButton.isHidden = false

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

    // MARK: - Seek Buttons

    private lazy var seekBackwardButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(makeSeekButtonImage(isForward: false), for: .normal)
        button.addTarget(self, action: #selector(handleSeekBackwardButton), for: .touchUpInside)
        button.accessibilityIdentifier = "video_player.pip_seek_backward_button"
        #if !os(tvOS)
        button.isPointerInteractionEnabled = true
        button.pointerStyleProvider = PointerStyle.highlight()
        #endif
        return button
    }()

    @objc
    private func handleSeekBackwardButton() {
        guard let delegate = controlsDelegate else { return }

        let interval = delegate.quickSeekInterval
        if let currentTime = controlMask?.timelineValues?.currentTime {
            let seekTime = max(0, currentTime - interval)
            delegate.seekToTime(seekTime, method: .unknown)
        }
    }

    private lazy var seekForwardButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(makeSeekButtonImage(), for: .normal)
        button.addTarget(self, action: #selector(handleSeekForwardButton), for: .touchUpInside)
        button.accessibilityIdentifier = "video_player.pip_seek_forward_button"
        #if !os(tvOS)
        button.isPointerInteractionEnabled = true
        button.pointerStyleProvider = PointerStyle.highlight()
        #endif
        return button
    }()

    @objc
    private func handleSeekForwardButton() {
        guard let delegate = controlsDelegate else { return }

        let interval = delegate.quickSeekInterval
        if let values = controlMask?.timelineValues {
            let seekTime = min(values.duration, values.currentTime + interval)
            delegate.seekToTime(seekTime, method: .unknown)
        }
    }

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(playPauseButton)
        addSubview(closeButton)
        addSubview(fullscreenButton)
        addSubview(seekBackwardButton)
        addSubview(seekForwardButton)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let sectionWidth = bounds.width / 4

        seekBackwardButton.center = CGPoint(x: sectionWidth, y: bounds.midY)
        playPauseButton.center = CGPoint(x: bounds.midX, y: bounds.midY)
        seekForwardButton.center = CGPoint(x: 3 * sectionWidth, y: bounds.midY)
        fullscreenButton.center = CGPoint(x: bounds.width - 24, y: 24)
    }

    func updateControlsVisible(visible: Bool, animated: Bool) {
        let alpha: CGFloat = visible ? 1 : 0
        let update = {
            self.playPauseButton.alpha = alpha
            self.closeButton.alpha = alpha
            self.fullscreenButton.alpha = alpha
            self.seekBackwardButton.alpha = alpha
            self.seekForwardButton.alpha = alpha
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

private extension PiPCustomControls {

    // MARK: - Button Composite Image

    /// Создает изображение с иконкой перемотки и числом секунд перемотки
    /// - Parameters:
    ///   - seconds: количество секунд для отображения. По умолчанию 10
    ///   - isForward: true для перемотки вперед
    /// - Returns: композитное изображение
    func makeSeekButtonImage(seconds: Int = 10, isForward: Bool = true) -> UIImage? {
        let size = CGSize(width: 36, height: 36)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            context.cgContext.saveGState()

            if isForward {
                context.cgContext.concatenate(CGAffineTransform(translationX: size.width, y: 0).scaledBy(x: -1, y: 1))
            }

            UIImage.ovk_replay36.draw(in: CGRect(origin: .zero, size: size))
            context.cgContext.restoreGState()

            let text = "\(seconds)" as NSString
            let fontSize: CGFloat = 12
            let font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)

            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.white
            ]

            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )

            text.draw(in: textRect, withAttributes: attributes)
        }
    }
}
