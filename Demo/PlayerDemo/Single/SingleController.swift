//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import AVFoundation
import CoreMedia.CMTime
import OVKit
#if canImport(OVKitMyTargetPlugin)
import OVKitMyTargetPlugin
#endif
import UIKit

class SingleController: ViewController {
    private lazy var playerView: PlayerView = {
        let controls = InplaceCustomControls(frame: .zero)
        #if OLD_ADS_OFF
        let playerView = PlayerView(frame: view.bounds, gravity: .fit, controls: controls)
        #else
        let playerView = PlayerView(frame: view.bounds, gravity: .fit, customControls: controls)
        #endif
        #if canImport(OVKitMyTargetPlugin)
        playerView.interstitialProvider = Environment.shared._enableInterstitial ? MyTargetInterstitialProvider() : nil
        #endif
        playerView.delegate = self
        playerView.soundOn = true
        playerView.limitMaxQualityToSurfaceSize = (ProcessInfo.processInfo.environment["DEMO_LIMIT_QUALITY_TO_SURFACE"] as? NSString)?.boolValue ?? false
        playerView.backgroundPlaybackPolicy = if (ProcessInfo.processInfo.environment["DEMO_DISABLE_BACKGROUND_PLAYBACK"] as? NSString)?.boolValue ?? false {
            .pause
        } else {
            .continueAudioAndVideo
        }
        playerView.onlyAudioMode = (ProcessInfo.processInfo.environment["DEMO_ENABLE_ONLY_AUDIO_PLAYBACK"] as? NSString)?.boolValue ?? false
        playerView.accessibilityIdentifier = "video_player.video_container"
        return playerView
    }()

    deinit {
        if isViewLoaded {
            playerView.stop()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Single video"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Import", style: .plain, target: self, action: #selector(Self.openImport))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "single_controller.import_button"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(Self.stopPlayer))

        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "single_controller.stop_button"
        view.addSubview(playerView)

        guard let video = Video.loadFromUserDefaults() else {
            print("No saved video in UserDefaults")
            let parser = URLParser()
            parser.parseURL(AppCoordinator.shared.initialVideoURL ?? "")
            let id = parser.vkVideoId ?? "-26006257_456245181"
            loadVideo(Video(id: id), for: playerView)
            return
        }

        loadVideo(video, for: playerView)
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

    // MARK: - Buttons

    @objc
    private func stopPlayer() {
        playerView.stop()
    }

    @objc
    private func openImport() {
        let vc = ImportController()
        vc.onImportVideo = { [unowned self] video in
            video.saveToUserDefaults()
            loadVideo(video, for: playerView)
        }
        present(vc, animated: true, completion: nil)
    }
}
