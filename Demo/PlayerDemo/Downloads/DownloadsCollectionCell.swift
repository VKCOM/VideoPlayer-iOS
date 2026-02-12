//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import UIKit

struct DownloadItemModel {

    enum ValidationState {
        case notChecked
        case checking
        case valid
        case invalid
    }

    let persistentItem: PersistentItem
    let video: Video
    let validationState: ValidationState
}

class DownloadsCollectionCell: UICollectionViewCell {
    static let insets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
    static let reuseId = String(describing: DownloadsCollectionCell.self)

    private(set) var model: DownloadItemModel?

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

    lazy var validationIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(titleLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(validationIcon)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    override func layoutSubviews() {
        super.layoutSubviews()

        let iconSize: CGFloat = 20
        let iconRightMargin: CGFloat = 8
        validationIcon.frame = CGRect(
            x: bounds.width - iconSize - iconRightMargin,
            y: (bounds.height - iconSize) / 2,
            width: iconSize,
            height: iconSize
        )

        let textRightMargin = validationIcon.frame.minX - iconRightMargin

        titleLabel.frame = CGRect(
            x: Self.insets.left,
            y: Self.insets.top,
            width: textRightMargin - Self.insets.left,
            height: bounds.height * 0.5
        )

        progressLabel.frame = CGRect(
            x: Self.insets.left,
            y: titleLabel.frame.maxY,
            width: textRightMargin - Self.insets.left,
            height: bounds.height - titleLabel.frame.maxY - Self.insets.bottom
        )
        progressBar.frame = CGRect(
            origin: .init(x: progressLabel.frame.minX, y: progressLabel.frame.maxY),
            size: .init(width: progressLabel.frame.width, height: 2)
        )

        titleLabel.textColor = tintColor
    }

    func update(with model: DownloadItemModel?) {
        self.model = model

        guard let model else {
            assertionFailure()
            return
        }

        titleLabel.text = model.video.title
        updateValidationIcon(for: model.validationState)

        DownloadService.shared.addListener(self)
        updateItemState()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        DownloadService.shared.removeListener(self)
    }

    // MARK: - Private

    @objc
    private func updateItemState() {
        guard let model else {
            return
        }

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
                if let progress {
                    self.progressBar.isHidden = false
                    self.progressBar.setProgress(progress, animated: true)
                } else {
                    self.progressBar.isHidden = true
                }
            }
        }
    }

    // MARK: - Private Helper Methods

    func updateValidationIcon(for state: DownloadItemModel.ValidationState) {
        switch state {
        case .notChecked:
            validationIcon.image = nil
            validationIcon.isHidden = true
        case .checking:
            validationIcon.image = UIImage(systemName: "arrow.2.circlepath.circle")
            validationIcon.tintColor = .systemGray2
            validationIcon.isHidden = false
        case .valid:
            validationIcon.image = UIImage(systemName: "checkmark.circle.fill")
            validationIcon.tintColor = .systemGreen
            validationIcon.isHidden = false
        case .invalid:
            validationIcon.image = UIImage(systemName: "xmark.circle.fill")
            validationIcon.tintColor = .systemRed
            validationIcon.isHidden = false
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
        guard item == model?.persistentItem else {
            return
        }

        updateItemState()
    }

    func persistenceManager(_ manager: PersistenceManager, didValidateItem item: PersistentItem, error: Error?) {
        guard item == model?.persistentItem else {
            return
        }

        let validationState: DownloadItemModel.ValidationState = error == nil ? .valid : .invalid
        guard let video = model?.video else { return }

        model = DownloadItemModel(persistentItem: item, video: video, validationState: validationState)
        updateValidationIcon(for: validationState)
    }
}
