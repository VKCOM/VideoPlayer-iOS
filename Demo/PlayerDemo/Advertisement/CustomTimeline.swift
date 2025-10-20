//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit

final class CustomTimelineAdsProvider: NSObject, AdsProvider {
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
}

class CustomSupplementedAdControlsView: SupplementedAdControlsView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
