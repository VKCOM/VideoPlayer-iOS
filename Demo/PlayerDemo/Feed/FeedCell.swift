import UIKit
import OVKit


protocol FeedCellUIDelegate: AnyObject {
    var enableAutoplay: Bool { get }
    func selectCell(model: FeedVideoModel, view: PlayerView)
}


class FeedCell: UITableViewCell, FocusOfInterestView {
    
    static let insets = UIEdgeInsets.zero
    static let reuseId = String(describing: FeedCell.self)
    
    
    private(set) var model: FeedVideoModel?
    
    
    var isFocusOfInterest: Bool {
        didSet {
            if isFocusOfInterest != oldValue {
                updateFocusedState()
            }
        }
    }
    
    weak var uiDelegate: FeedCellUIDelegate?
    
    
    private(set) lazy var playerView: PlayerView = {
        let player = PlayerView(frame: .zero, gravity: .fill, customControls: FeedControlsView(frame: .zero))
        let context = DemoPlayerViewContext()
        context.openWithDetail = true
        player.context = context
        return player
    }()
    
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        isFocusOfInterest = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(playerView)
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        playerView.stop()
    }
    
    // MARK: - Public
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerView.frame = contentView.bounds.inset(by: FeedCell.insets).integral
    }

    
    func update(with model: FeedVideoModel?) {
        self.model = model
        
        guard let model = model else {
            assertionFailure()
            return
        }

        playerView.video = model.item
        updateAutoplayBehaviour()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.playerView.prepareForReuse()
    }
    
    
    func willDisplay() {
        playerView.playerViewOnScreen = true
        
        NotificationCenter.default.addObserver(forName: .feedAutoplayModeChanged, object: nil, queue: nil) { [weak self] _ in
            self?.updateAutoplayBehaviour()
        }
    }
    
    
    func didEndDisplaying() {
        playerView.playerViewOnScreen = false
        
        NotificationCenter.default.removeObserver(self, name: .feedAutoplayModeChanged, object: nil)
    }
    
    
    func touch() {
        updateFocusedState()
    }
    
    // MARK: - Private
    
    private func updateFocusedState() {
#if DEBUG
        if Environment.shared._focusDebug {
            self.contentView.layer.borderWidth = isFocusOfInterest ? 2.0 : 0.0
            self.contentView.layer.borderColor = isFocusOfInterest ? UIColor.red.cgColor : UIColor.clear.cgColor
        } else {
            self.contentView.layer.borderWidth = 0.0
        }
#endif
        if isFocusOfInterest, uiDelegate?.enableAutoplay == true {
            playerView.play(userInitiated: false)
        } else if !isFocusOfInterest, !playerView.isPlayingOnExternalDevice {
            playerView.paused = true
        }
    }
    
    
    private func updateAutoplayBehaviour() {
        playerView.startButtonBehavior = .feed(autoplay: uiDelegate?.enableAutoplay ?? false)
    }

    
    @objc private func handleTap() {
        guard let model = self.model else { return }
        uiDelegate?.selectCell(model: model, view: playerView)
    }
}
