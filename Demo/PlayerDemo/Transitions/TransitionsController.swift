import UIKit
import OVKit
import CoreMedia.CMTime
import AVFoundation


class TransitionsController: ViewController {
    
    enum TransitionStyle {
        // Встроенная анимация
        case standard
        
        // Настраиваемая анимация
        case custom
    }
    
    private lazy var firstPlayer: PlayerView = {
        let player = PlayerView(frame: .zero, gravity: .fit, customControls: DiscoverControlsView(standardControlsWithFrame: .zero))
        player.delegate = self
        return player
    }()
    
    private lazy var secondPlayer: PlayerView = {
        let player = PlayerView(frame: .zero, gravity: .fill, customControls: FeedControlsView(frame: .zero))
        player.delegate = self
        return player
    }()
    
    private lazy var defaultButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Standard", for: .normal)
        b.setImage(UIImage(systemName: "rectangle.2.swap"), for: .normal)
        b.addTarget(self, action: #selector(handleSwapButton(_:)), for: .touchUpInside)
        b.sizeToFit()
        return b
    }()
    
    private lazy var customButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Custom", for: .normal)
        b.setImage(UIImage(systemName: "rectangle.2.swap"), for: .normal)
        b.addTarget(self, action: #selector(handleSwapButton(_:)), for: .touchUpInside)
        b.sizeToFit()
        return b
    }()
    
    
    deinit {
        if isViewLoaded {
            firstPlayer.stop()
            secondPlayer.stop()
        }
    }
    
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Transitions"
        
        view.addSubview(firstPlayer)
        view.addSubview(secondPlayer)
        view.addSubview(defaultButton)
        view.addSubview(customButton)
        
        loadVideo()
    }
    
    
    private func loadVideo() {
        let uiItems = [firstPlayer, secondPlayer, defaultButton, secondPlayer]
        uiItems.forEach { $0.isHidden = true }
        
        startActivity()
        ApiSession.shared?.fetch(videoIds: ["-26006257_456245181"]) { [weak self] videos, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.stopActivity()
                if let error {
                    self.showError(error.localizedDescription)
                    return
                }
                guard let video = videos?.first else {
                    self.showError("Something went wrong")
                    return
                }
                uiItems.forEach { $0.isHidden = false }
                self.firstPlayer.video = video
            }
        }
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        firstPlayer.playerViewOnScreen = true
        secondPlayer.playerViewOnScreen = true
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        firstPlayer.playerViewOnScreen = false
        secondPlayer.playerViewOnScreen = false
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeFrame = view.bounds
            .inset(by: view.safeAreaInsets)
            .inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        let ratio = CGSize(width: 16, height: 9)
        
        let buttonsWidth = defaultButton.bounds.width + customButton.bounds.width + 32
        let buttonsX = safeFrame.minX + (safeFrame.width - buttonsWidth) / 2
        
        if safeFrame.width > safeFrame.height {
            let maxPlayerWidth = floor((safeFrame.width - 32) / 2)
            let maxPlayerHeight = safeFrame.height - max(defaultButton.bounds.height, customButton.bounds.height) - 32
            let leftPlayerFrame = CGRect(x: safeFrame.minX, y: safeFrame.minY, width: maxPlayerWidth, height: maxPlayerHeight)
            let rightPlayerFrame = CGRect(x: safeFrame.maxX - maxPlayerWidth, y: safeFrame.minY, width: maxPlayerWidth, height: maxPlayerHeight)
            firstPlayer.frame = AVMakeRect(aspectRatio: ratio, insideRect: leftPlayerFrame)
            secondPlayer.frame = AVMakeRect(aspectRatio: ratio, insideRect: rightPlayerFrame)
        } else {
            let maxPlayerHeight = (safeFrame.height - max(defaultButton.bounds.height, customButton.bounds.height) - 64) / 2
            let topPlayerFrame = CGRect(x: safeFrame.minX, y: safeFrame.minY, width: safeFrame.width, height: maxPlayerHeight)
            let bottomPlayerFrame = CGRect(x: safeFrame.minX, y: safeFrame.maxY - maxPlayerHeight, width: safeFrame.width, height: maxPlayerHeight)
            firstPlayer.frame = AVMakeRect(aspectRatio: ratio, insideRect: topPlayerFrame)
            secondPlayer.frame = AVMakeRect(aspectRatio: ratio, insideRect: bottomPlayerFrame)
        }
        
        defaultButton.frame.origin = CGPoint(x: buttonsX, y: firstPlayer.frame.maxY + 32)
        customButton.frame.origin = CGPoint(x: defaultButton.frame.maxX + 32, y: defaultButton.frame.origin.y)
    }
    
    
    // MARK: - Buttons
    
    @objc private func handleSwapButton(_ sender: UIView) {
        let style: TransitionStyle = sender == customButton ? .custom : .standard
        if firstPlayer.video != nil {
            performTransition(from: firstPlayer, to: secondPlayer, style: style)
        } else if secondPlayer.video != nil {
            performTransition(from: secondPlayer, to: firstPlayer, style: style)
        }
    }
    
    
    // MARK: - Transition
    
    private func performTransition(from source: PlayerView, to destination: PlayerView, style: TransitionStyle) {
        guard let transition = source.createAnimatedTransition(to: destination, in: view) else {
            return
        }
        
        transition.prepare()

        switch style {
        case .standard:
            UIView.animate(withDuration: 1.0) {
                transition.animateToDestination()
            } completion: { _ in
                transition.finish(completed: true)
            }
            
        case .custom:
            if let floating = transition.floatingView {
                UIView.animateKeyframes(withDuration: 1.0, delay: 0.0) {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                        transition.animateToDestination()
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                        floating.transform = .identity.scaledBy(x: 0.5, y: 0.5)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        floating.transform = .identity
                    }
                } completion: { _ in
                    transition.finish(completed: true)
                }
            }
        }
    }
}
