//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import UIKit

class ImportFormatView: UIButton {
    var readyToApply: Bool {
        urlParser.vkVideoId != nil || urlParser.rawUrl != nil
    }

    private let urlParser = URLParser()

    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = true
        clipsToBounds = true
        layer.cornerRadius = 7
        setTitle("Unknown", for: .normal)
        setTitleColor(.secondaryLabel, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        sizeToFit()
        frame = CGRect(x: 0, y: 0, width: bounds.width + 12, height: 28)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeVideo() -> Video? {
        urlParser.makeVideo()
    }

    func correctFormat(_ format: VideoFileFormat) {
        urlParser.correctFormat(format)
        updateAppearance()
    }

    func provideText(_ string: String) {
        defer {
            updateAppearance()
        }

        urlParser.parseURL(string)
    }

    private func updateAppearance() {
        var text = "Unknown"
        var interaction = false
        if urlParser.vkVideoId != nil {
            text = "VK Video"
        } else {
            interaction = true
        }
        if let format = urlParser.rawUrl?.format {
            text = format.rawValue
        }

        guard title(for: .normal) != text else {
            return
        }

        let maxX = frame.maxX
        let y = frame.minY
        setTitle(text, for: .normal)
        sizeToFit()
        backgroundColor = interaction ? .quaternarySystemFill : .clear
        isUserInteractionEnabled = interaction
        frame = CGRect(x: maxX - bounds.width - 12, y: y, width: bounds.width + 12, height: 28)
    }
}
