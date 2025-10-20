//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import OVKResources
import UIKit

public enum FeedIndicatorViewState {
    case idle
    case loading
    case playing
}

public class FeedIndicatorView: UIView {
    // MARK: - Controls

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        return label
    }()

    private let activityIndicator = ActivityIndicator(style: .feed)

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(textLabel)
        addSubview(activityIndicator)

        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        layer.cornerRadius = 6.0

        updateState()
        updateText()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal

    var gifAppearance = false {
        didSet {
            updateState()
            updateText()
        }
    }

    override public var isHidden: Bool {
        didSet { updateState() }
    }

    var state = FeedIndicatorViewState.idle {
        didSet {
            guard state != oldValue else {
                return
            }

            updateState()
        }
    }

    var time: TimeInterval = 0.0 {
        didSet { updateText() }
    }

    // MARK: - Layout

    override public func didMoveToWindow() {
        super.didMoveToWindow()

        updateState()
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var timeLabelSize = textLabel.sizeThatFits(size)

        timeLabelSize.height += 2 * 4.0
        timeLabelSize.width += 2 * 8.0

        if !activityIndicator.isHidden {
            timeLabelSize.width += 16.0
        }

        return timeLabelSize
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        var timeLabelX = 8.0

        if !activityIndicator.isHidden {
            let frameOrigin = CGPoint(
                x: 8.0,
                y: (bounds.height - 10.0) / 2
            )
            let frameSize = CGSize(width: 10.0, height: 10.0)
            activityIndicator.frame = CGRect(origin: frameOrigin, size: frameSize)

            timeLabelX = activityIndicator.frame.maxX + 6.0
        }

        textLabel.sizeToFit()
        var timeLabelFrame = textLabel.frame
        timeLabelFrame.origin = CGPoint(
            x: timeLabelX,
            y: (bounds.height - timeLabelFrame.height) / 2.0
        )
        textLabel.frame = timeLabelFrame
    }

    // MARK: - Private

    private func updateState() {
        if isHidden || window == nil {
            activityIndicator.isRunning = false
            return
        }

        switch state {
        case .idle,
             .playing:
            activityIndicator.isRunning = false
        case .loading:
            activityIndicator.isRunning = true
        }

        sizeToFit()
        setNeedsLayout()
    }

    private func updateText() {
        let text = gifAppearance ? "GIF" : String.ovk_formatDuration(from: Int(time))
        guard text != textLabel.text else {
            return
        }

        textLabel.text = text
        textLabel.sizeToFit()

        sizeToFit()
        setNeedsLayout()
    }
}
