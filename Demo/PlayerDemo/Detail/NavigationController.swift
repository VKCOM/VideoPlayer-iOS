//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import UIKit

class NavigationController: UINavigationController, PlayerViewProvider, FullscreenSupplementaryController {
    var dismissGestureRecognizer: UIPanGestureRecognizer? {
        supplementary?.dismissGestureRecognizer
    }

    var supplementaryType: OVKit.SupplementaryControllerType {
        .any
    }

    var currentPlayerView: PlayerView? {
        (topViewController as? PlayerViewProvider)?.currentPlayerView
    }

    func didReceivePlayer() {
        (topViewController as? PlayerViewProvider)?.didReceivePlayer()
    }

    var providesCloseButton: Bool {
        supplementary?.providesCloseButton ?? false
    }

    var hidesPlayerControls: Bool {
        supplementary?.hidesPlayerControls ?? false
    }

    var preferredSideBySideWidth: NSNumber? {
        supplementary?.preferredSideBySideWidth
    }

    var sideBySideMargin: NSNumber? {
        supplementary?.sideBySideMargin
    }

    var preferredBottomSheetHeight: NSNumber? {
        supplementary?.preferredBottomSheetHeight
    }

    var bottomSheetMargin: NSNumber? {
        supplementary?.bottomSheetMargin
    }

    var customControlsSafeInsets: NSValue? {
        supplementary?.customControlsSafeInsets
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        topViewController?.supportedInterfaceOrientations ?? .all
    }

    var shouldBeClosedOnRotateToPortrait: Bool {
        false
    }

    // MARK: - Helpers

    private var supplementary: FullscreenSupplementaryController? {
        topViewController as? FullscreenSupplementaryController
    }
}
