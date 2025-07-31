import UIKit
import OVKit
import CoreMedia.CMTime
import AVFoundation

class SingleController: ViewController {
    
    private lazy var playerView: PlayerView = {
        let controls = InplaceCustomControls(frame: .zero)
        let player = PlayerView(frame: view.bounds, gravity: .fit, customControls: controls)
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
        
        navigationItem.title = "Single video"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Import", style: .plain, target: self, action: #selector(Self.openImport))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(Self.stopPlayer))
        
        view.addSubview(playerView)
        
        guard let video = Video.loadFromUserDefaults() else {
            print("No saved video in UserDefaults")
            loadVideo(Video(id: "-26006257_456245181"), for: playerView)
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
    
    @objc private func stopPlayer() {
        playerView.stop()
    }
    
    
    @objc private func openImport() {
        let vc = ImportController()
        vc.onImportVideo = { [unowned self] video in
            video.saveToUserDefaults()
            loadVideo(video, for: playerView)
        }
        present(vc, animated: true, completion: nil)
    }
}
