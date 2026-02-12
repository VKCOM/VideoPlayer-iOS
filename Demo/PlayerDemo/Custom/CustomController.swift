//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import AVFoundation
import OVKit
import UIKit

class CustomController: ViewController {
    private lazy var playerView: PlayerView = {
        let controls = InplaceCustomControls(frame: .zero)
        #if OLD_ADS_OFF
        let player = PlayerView(frame: view.bounds, gravity: .fit, controls: controls)
        #else
        let player = PlayerView(frame: view.bounds, gravity: .fit, customControls: controls)
        #endif
        player.delegate = self
        player.soundOn = true
        player.backgroundPlaybackPolicy = .continueAudioAndVideo
        player.accessibilityIdentifier = "video_player.video_container"
        return player
    }()

    deinit {
        if isViewLoaded {
            playerView.stop()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Custom"
        view.addSubview(playerView)

        let parser = URLParser()
        parser.parseURL(AppCoordinator.shared.initialVideoURL ?? "http://vkvideo.ru/video-26006257_456245181")
        if let video = parser.makeVideo() {
            loadVideo(video, for: playerView)
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .all
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        playerView.playerViewOnScreen = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        playerView.playerViewOnScreen = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let safeFrame = view.bounds.inset(by: view.safeAreaInsets)
        var ratio = playerView.video?.size ?? .zero
        if ratio.width == 0 || ratio.height == 0 {
            ratio = CGSize(width: 16, height: 9)
        }
        playerView.frame = AVMakeRect(aspectRatio: ratio, insideRect: safeFrame)
    }
}
