//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import UIKit

class FullscreenAdsControlsViewContainer: UIView, OVKit.ControlsViewContainer {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ControlsViewContainer

    var surfaceSize: CGSize? {
        .init(
            width: bounds.size.width,
            height: bounds.size.width / (videoNaturalSize?.aspectRatio ?? 1.777)
        )
    }

    var videoNaturalSize: CGSize? {
        .init(width: 1920, height: 1080)
    }

    var noBorderScale: CGFloat { 1.0 }

    var affineTransform: CGAffineTransform?

    var smallSurfaceAppearance = false

    var isInFullscreen: Bool { true }

    func updateCoverView() {}
}

private extension CGSize {
    var aspectRatio: CGFloat {
        width / height
    }
}
