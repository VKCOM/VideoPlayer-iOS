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
    private lazy var controls = InplaceCustomControls(frame: .zero)

    // MARK: - Prefetch Properties

    private let prefetchResourceLoader = DemoResourceLoader()
    private var prefetchTask: URLSessionDownloadTask?
    private var prefetchProgressObservation: NSKeyValueObservation?

    // MARK: - Player View

    private lazy var playerView: PlayerView = {
        #if OLD_ADS_OFF
        let playerView = PlayerView(frame: view.bounds, gravity: .fill, controls: controls)
        #else
        let playerView = PlayerView(frame: view.bounds, gravity: .fill, customControls: controls)
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
        prefetchTask?.cancel()
        if isViewLoaded {
            playerView.stop()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Single video"
        let importButton = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(Self.openImport))
        let screencastButton = UIBarButtonItem(image: .ovk_screencastOutline24, style: .plain, target: self, action: #selector(Self.openScreencastMenu))
        importButton.accessibilityIdentifier = "single_controller.import_button"
        screencastButton.accessibilityIdentifier = "single_controller.broadcast_button"

        navigationItem.leftBarButtonItems = [importButton, screencastButton]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(Self.stopPlayer))

        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "single_controller.stop_button"
        view.addSubview(playerView)

        setupPrefetchControls()

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

    @objc
    private func openScreencastMenu() {
        controls.handleScreencastButton()
    }
}

// MARK: - Prefetch Cache Playback

extension SingleController {
    private func setupPrefetchControls() {
        controls.onPrefetchRequested = { [weak self] video, format in
            self?.startPrefetch(for: video, format: format)
        }
    }

    private func startPrefetch(for videoType: VideoType, format: VideoFileFormat) {
        guard let video = videoType as? Video,
              let remoteURL = video.videoURL(format),
              let ovkdemoURL = remoteURL.withDemoResourceLoaderScheme
        else { return }

        controls.showPrefetchProgress(0)

        let task = URLSession.shared.downloadTask(with: remoteURL) { [weak self] tempURL, _, error in
            guard let self else { return }

            prefetchProgressObservation = nil

            guard error == nil, let tempURL else {
                DispatchQueue.main.async { self.controls.hidePrefetchProgress(cached: false) }
                return
            }

            let destURL = cachedFileURL(for: video)
            try? FileManager.default.removeItem(at: destURL)
            try? FileManager.default.moveItem(at: tempURL, to: destURL)

            DispatchQueue.main.async {
                self.prefetchResourceLoader.localFileURL = destURL
                video.files = [format: ovkdemoURL]
                self.controls.hidePrefetchProgress(cached: true)
                self.playerView.video = nil
                self.playerView.video = video
            }
        }

        prefetchProgressObservation = task.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            DispatchQueue.main.async {
                self?.controls.showPrefetchProgress(Float(progress.fractionCompleted))
            }
        }

        prefetchTask?.cancel()
        prefetchTask = task
        task.resume()
    }

    private func cachedFileURL(for video: Video) -> URL {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return cacheDir.appendingPathComponent("prefetch_\(video.videoId).mp4")
    }

    func playerResourceLoaderDelegate(for playerView: PlayerView) -> (any AVAssetResourceLoaderDelegate)? {
        prefetchResourceLoader.localFileURL != nil ? prefetchResourceLoader : nil
    }

    func playerResourceLoaderQueue(for playerView: PlayerView) -> DispatchQueue? {
        DispatchQueue(label: "com.ovplayerkit.resource-loader-delegate")
    }
}
