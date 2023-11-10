import UIKit
import OVKit
import AVFoundation


class CustomControlsController: ViewController {
    
    private lazy var liveToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .red
        return toggle
    }()
    
    private lazy var playerView: PlayerView = {
        let controls = InplaceCustomControls(frame: .zero)
        let player = PlayerView(frame: .zero, gravity: .fit, customControls: controls)
        player.delegate = self
        player.soundOn = true
        return player
    }()
    
    
    deinit {
        if isViewLoaded {
            playerView.stop()            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Custom Controls"
        liveToggle.addTarget(self, action: #selector(Self.handleLiveToggle), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: liveToggle)
        
        view.addSubview(playerView)
        loadVideo(Video(id: "-26006257_456245180"), for: playerView)
        
        PlayerManager.shared.customPiPControlsFactory = { [weak self] in
            if let self, (self.tabBarController?.selectedViewController as? NavigationController)?.topViewController === self {
                return PiPCustomControls(frame: .zero)
            }
            return PiPControlsView(frame: .zero)
        }
        
        PlayerManager.shared.customFullscreenControlsFactory = { [weak self] (video, fromPlayerView) in
            if let self, self.playerView === fromPlayerView {
                return FullscreenCustomControls(frame: .zero)
            }
            return FullscreenControlsView(frame: .zero)
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
        let ratio = playerView.video?.size ?? CGSize(width: 16, height: 9)
        playerView.frame = AVMakeRect(aspectRatio: ratio, insideRect: safeFrame)
    }
    
    
    @objc private func handleLiveToggle() {
        let videoId = liveToggle.isOn ? "-339767_456244698" : "-26006257_456245180"
        loadVideo(Video(id: videoId), for: playerView)
    }
}
