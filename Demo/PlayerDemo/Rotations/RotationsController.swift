//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import AVFoundation
import OVKit
import UIKit

class RotationsController: ViewController {
    private lazy var horizontalPlayerView: PlayerView = {
        let controls = InplaceCustomControls(frame: .zero)
        #if OLD_ADS_OFF
        let player = PlayerView(frame: view.bounds, gravity: .fit, controls: controls)
        #else
        let player = PlayerView(frame: view.bounds, gravity: .fit, customControls: controls)
        #endif
        player.delegate = self
        player.soundOn = true
        player.backgroundPlaybackPolicy = .continueAudioAndVideo
        return player
    }()

    private lazy var verticalPlayerView: PlayerView = {
        #if OLD_ADS_OFF
        let player = PlayerView(frame: view.bounds, gravity: .fit, controls: InplaceCustomControls(frame: .zero))
        #else
        let player = PlayerView(frame: view.bounds, gravity: .fit, customControls: InplaceCustomControls(frame: .zero))
        #endif
        player.delegate = self
        player.soundOn = true
        player.backgroundPlaybackPolicy = .continueAudioAndVideo
        return player
    }()

    private lazy var controlledPlayerView: PlayerView = horizontalPlayerView

    deinit {
        if isViewLoaded {
            horizontalPlayerView.stop()
            verticalPlayerView.stop()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Rotations"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Switch player", style: .plain, target: self, action: #selector(tapSwitchPlayer))

        view.addSubview(horizontalPlayerView)
        view.addSubview(verticalPlayerView)

        NotificationCenter.default.addObserver(self, selector: #selector(handleRotate), name: UIDevice.orientationDidChangeNotification, object: nil)

        loadVideo(Video(id: "-26006257_456245180"), for: horizontalPlayerView)
        loadVideo(Video(id: "-22822305_456242444"), for: verticalPlayerView)
        tapSwitch()
    }

    @objc
    func tapSwitch() {
        controlledPlayerView.autoRotateToLandscapeInFullscreenIfPossible.toggle()
        updateAutoRotateState()
    }

    func updateAutoRotateState() {
        let value = controlledPlayerView.autoRotateToLandscapeInFullscreenIfPossible
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Auto: \(value)", style: .plain, target: self, action: #selector(tapSwitch))
        highlightCurrentPlayer()
    }

    func highlightCurrentPlayer() {
        UIView.animate(withDuration: 0.2) { [controlledPlayerView] in
            controlledPlayerView.alpha = 0.2
        } completion: { [controlledPlayerView] _ in
            UIView.animate(withDuration: 0.2) {
                controlledPlayerView.alpha = 1
            }
        }
    }

    @objc
    func tapSwitchPlayer() {
        controlledPlayerView = controlledPlayerView == horizontalPlayerView ? verticalPlayerView : horizontalPlayerView
        updateAutoRotateState()
    }

    @objc
    func handleRotate() {
        guard PlayerView.canMaximizeToFullscreenInLandscape(from: self) else {
            return
        }

        controlledPlayerView.maximizeToFullscreenFromLandscapeOrientation()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        horizontalPlayerView.playerViewOnScreen = true
        verticalPlayerView.playerViewOnScreen = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        horizontalPlayerView.playerViewOnScreen = false
        verticalPlayerView.playerViewOnScreen = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let safeFrame = view.bounds.inset(by: view.safeAreaInsets)
        var ratio = horizontalPlayerView.video?.size ?? .zero
        if ratio.width == 0 || ratio.height == 0 {
            ratio = CGSize(width: 16, height: 9)
        }

        let frame = AVMakeRect(aspectRatio: ratio, insideRect: safeFrame)
            .offsetBy(dx: 0, dy: -200)
            .inset(by: .init(top: 20, left: 20, bottom: 20, right: 50))
        horizontalPlayerView.frame = AVMakeRect(aspectRatio: ratio, insideRect: frame)

        verticalPlayerView.frame = .init(x: 20, y: 400, width: 9 * 20, height: 16 * 20)
        verticalPlayerView.center.x = view.center.x + 80
    }
}

class RotationsNavController: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
}
