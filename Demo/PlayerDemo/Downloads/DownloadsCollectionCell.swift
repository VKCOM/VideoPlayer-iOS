import UIKit
import OVKit


protocol DownloadsCollectionCellUIDelegate: AnyObject {
    
    func cancelDownload(of model: DownloadItemModel)
}


struct DownloadItemModel {
    
    let persistentItem: PersistentItem
    let video: Video
}


class DownloadsCollectionCell: UICollectionViewCell {
    
    static let insets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
    static let reuseId = String(describing: DownloadsCollectionCell.self)
    
    private(set) var model: DownloadItemModel?
    
    weak var uiDelegate: DownloadsCollectionCellUIDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var progressBar = UIProgressView(progressViewStyle: .bar)
    
    private lazy var cancelButton: UIButton = {
        let image = UIImage(systemName: "x.circle.fill")!
        let btn = UIButton(frame: CGRect(origin: .zero, size: .init(width: 22, height: 22)))
        btn.setImage(image, for: .normal)
        btn.tintColor = .systemRed
        return btn
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(titleLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(cancelButton)
        contentView.addSubview(progressBar)
        
        cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cancelButton.center = CGPoint(x: bounds.width - cancelButton.bounds.width/2 - Self.insets.right,
                                      y: bounds.height / 2)
        
        titleLabel.frame = CGRect(x: Self.insets.left,
                                  y: Self.insets.top,
                                  width: cancelButton.frame.minX - Self.insets.right,
                                  height: bounds.height * 0.5)
        
        progressLabel.frame = CGRect(x: Self.insets.left,
                                     y: titleLabel.frame.maxY,
                                     width: cancelButton.frame.minX  - Self.insets.right,
                                     height: bounds.height - titleLabel.frame.maxY - Self.insets.bottom)
        progressBar.frame = CGRect(origin: .init(x: progressLabel.frame.minX, y: progressLabel.frame.maxY),
                                   size: .init(width: progressLabel.frame.width, height: 2))
        
        titleLabel.textColor = tintColor
    }

    func update(with model: DownloadItemModel?) {
        self.model = model
        
        guard let model = model else {
            assertionFailure()
            return
        }
        
        titleLabel.text = model.video.title
        
        DownloadService.shared.addListener(self)
        updateItemState()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        DownloadService.shared.removeListener(self)
    }
    
    // MARK: - Private
    
    @objc private func handleCancelButton() {
        guard let model = self.model else { return }
        uiDelegate?.cancelDownload(of: model)
    }
    
    @objc private func updateItemState() {
        guard let model = self.model else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            let state = DownloadService.shared.getState(of: model.persistentItem)
            let totalSize = Double(model.persistentItem.estimatedSizeOnDisk) / 1024 / 1024 // MB
            let labelText: String
            let progress: Float?
            switch state.downloadState {
            case .created:
                labelText = "Checking disk space"
                progress = nil
            case .pending:
                labelText = "In Queue"
                progress = nil
            case .suspended:
                labelText = "Paused"
                progress = state.progress
            case .finished:
                labelText = "Downloaded (\(totalSize.rounded())MB)"
                progress = nil
            case .error:
                labelText = "Error \(state.error?.localizedDescription ?? "-")"
                progress = nil
            case .downloading:
                let downloadedSize = Double(state.progress) * totalSize
                labelText = "Progress: \(floor(state.progress * 100))% (\(downloadedSize.rounded())MB/\(totalSize.rounded())MB)"
                progress = state.progress
            @unknown default:
                fatalError()
            }
            
            DispatchQueue.main.async {
                self.progressLabel.text = labelText
                if let progress = progress {
                    self.progressBar.isHidden = false
                    self.progressBar.setProgress(progress, animated: true)
                } else {
                    self.progressBar.isHidden = true
                }
            }
        }
    }
}

extension DownloadsCollectionCell: PersistenceManagerListener {
    
    func persistenceManager(_ manager: PersistenceManager, didFailWithError error: Error) {
        // Ignore
    }
    
    func persistenceManager(_ manager: PersistenceManager, added item: PersistentItem) {
        // Ignore
    }
    
    func persistenceManager(_ manager: PersistenceManager, removed item: PersistentItem) {
        // Ignore
    }
    
    func persistenceManager(_ manager: PersistenceManager, updatedStatusOf item: PersistentItem) {
        if item == self.model?.persistentItem {
            self.updateItemState()
        }
    }
}
