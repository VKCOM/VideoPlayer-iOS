import UIKit
import OVKit
import CoreMedia.CMTime
import OVKResources


class DetailController: ViewController {

    private var video: VideoType?

    
    private let contentStack: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private let buttonsStack: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let descriptionView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = UIColor.secondaryLabel
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    private lazy var copyUrlButton: UIButton = {
        let image = UIImage(systemName: "doc.on.doc.fill")!.withRenderingMode(.alwaysTemplate)
        let btn = UIButton(frame: .zero)
        btn.setImage(image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleCopyUrlButton), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var downloadButton: UIButton = {
        let image = UIImage(systemName: "arrow.down.to.line")!.withRenderingMode(.alwaysTemplate)
        let btn = UIButton(frame: .zero)
        btn.setImage(image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleDownloadButton), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var loopButton: UIButton = {      
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(systemName: "repeat.1")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleLoopButton), for: .touchUpInside)
        return btn
    }()
    
    
    // MARK: - Initialization
    
    
    init(video: VideoType?) {
        self.video = video
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var onClose: VoidBlock?
    
    
    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentStack)
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(buttonsStack)
        contentStack.addArrangedSubview(descriptionView)
        
        buttonsStack.addArrangedSubview(copyUrlButton)
        buttonsStack.addArrangedSubview(downloadButton)
        buttonsStack.addArrangedSubview(loopButton)
        
        let margin: CGFloat = 8.0
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin),
            contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            buttonsStack.heightAnchor.constraint(equalToConstant: 38),
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                            target: self,
                                                            action: #selector(closeDetail))
        
        updateState()
    }
    
    
    // MARK: - Actions
    
    
    @objc private func closeDetail() {
        onClose?()
    }
    
    
    @objc private func handleCopyUrlButton() {
        guard let video = self.video else { return }
        
        let actionSheet = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Copy link", style: .default) { _ in
            UIPasteboard.general.url = URL(string: "https://vk.com/video\(video.videoId)")
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    
    @objc private func handleDownloadButton() {
        guard let video = self.video else { return }
        
        DownloadService.shared.downloadVideo(video)
        updateDownloadState()
    }
    
    
    @objc private func handleLoopButton() {
        guard let looped = video?.repeated else { return }
        video?.repeated = !looped
        updateLoopedState()
    }
    
    
    // MARK: - Private
    
    
    private func updateState() {
        var title = "No video"
        var description = "No video"
        if let video = video as? Video {
            title = video.title ?? "No title"
            description = VideoFileFormat.allCases
                .compactMap {
                    if let url = video.videoURL($0) {
                        return "\($0.rawValue)\n\(url.absoluteString)"
                    } else {
                        return nil
                    }
                }
                .joined(separator: "\n\n")
        }
        titleLabel.text = title
        descriptionView.text = description
        
        updateLoopedState()
        updateDownloadState()
    }
    
    
    private func updateDownloadState() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self, let video = self.video else { return }
            
            let videoIsDownloaded = DownloadService.shared.hasVideo(video)
            DispatchQueue.main.async {
                self.downloadButton.isEnabled = !videoIsDownloaded
            }
        }
    }
    
    
    private func updateLoopedState() {
        let looped = video?.repeated ?? false
        loopButton.tintColor = looped ? .systemRed : .label
    }
    
    
    private func videoAspectRatio() -> CGFloat {
        guard let outputSize = video?.size else {
            return 1.0
        }
        
        if outputSize == .zero {
            return 1.0
        } else {
            let ratio = outputSize.height / outputSize.width
            return ratio > 1 ? 1 : ratio
        }
    }
    
    
    lazy var dismissGestureRecognizer: UIPanGestureRecognizer? = {
        let g = UIPanGestureRecognizer()
        view.addGestureRecognizer(g)
        return g
    }()
}


// MARK: - FullscreenSupplementaryController


extension DetailController: FullscreenSupplementaryController {
    
    var supplementaryType: OVKit.SupplementaryControllerType {
        .any
    }
    
    var providesCloseButton: Bool {
        false
    }
    
    var hidesPlayerControls: Bool {
        false
    }
    
    var preferredSideBySideWidth: NSNumber? {
        nil
    }
    
    var sideBySideMargin: NSNumber? {
        nil
    }
    
    var preferredBottomSheetHeight: NSNumber? {
        nil
    }
    
    var bottomSheetMargin: NSNumber? {
        nil
    }
    
    var customControlsSafeInsets: NSValue? {
        nil
    }
}
