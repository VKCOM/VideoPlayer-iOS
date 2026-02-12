//
//  Copyright © 2024 - present, VK. All rights reserved.
//

#if !OLD_ADS_OFF

import OVKit
import OVKitUIComponents

final class CustomTimelineAdsProvider: NSObject, OVKit.AdsProvider {
    func makeAdControls(for ads: any VideoAdsType, hasSupplementaryControls: Bool, interactiveAdsPlaying: Bool, inPiP: Bool) -> any PlayerControlsViewProtocol {
        let controls = CustomSupplementedAdControlsView(frame: .zero)
        controls.isInternalSupplementaryEnabled = true
        controls.timelineView.progressColor = .red
        controls.timelineView.rounded = false
        controls.timelineView.roundedProgress = false
        var tFrame = controls.timelineView.frame
        tFrame.size.height = 10
        controls.timelineView.frame = tFrame
        return controls
    }

    func makeSupplementaryControls(for ads: (any OVKit.AdCallToAction)?) -> (any OVKit.PlayerControlsViewProtocol)? {
        nil
    }
}

class CustomSupplementedAdControlsView: OVKitUIComponents.SupplementedAdControlsView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
