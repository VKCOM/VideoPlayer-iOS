//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import UIKit

class DownloadsController: CollectionController {
    private var itemModels = [DownloadItemModel]()

    init() {
        let layout = UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
        super.init(collectionViewLayout: layout)

        configureSwipeActions()
    }

    private func configureSwipeActions() {
        guard collectionViewLayout is UICollectionViewCompositionalLayout else { return }

        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let self = self else {
                return nil
            }

            let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
                guard let self = self else {
                    completion(true)
                    return
                }

                let model = self.itemModels[indexPath.item]
                DownloadService.shared.delete(item: model.persistentItem)
                completion(true)
            }

            deleteAction.image = UIImage(systemName: "trash.fill")
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }

        let newLayout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.setCollectionViewLayout(newLayout, animated: false)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Downloads"

        configureButtons()

        collectionView.register(DownloadsCollectionCell.self, forCellWithReuseIdentifier: DownloadsCollectionCell.reuseId)
        collectionView.register(
            DownloadsCollectionFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: DownloadsCollectionFooter.reuseId
        )
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false

        collectionView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isFirstAppearance {
            DownloadService.shared.addListener(self)
        }

        updateDataSource()
    }

    // MARK: - Private

    private func updateDataSource() {
        DispatchQueue.global(qos: .userInitiated).async {
            let items: [DownloadItemModel] = DownloadService.shared.items.map { item in
                let video = DownloadService.shared.getVideo(of: item, forLocalPlayback: true)
                let state = DownloadService.shared.getState(of: item)

                let validationState: DownloadItemModel.ValidationState
                switch state.downloadState {
                case .finished:
                    if let existingModelIndex = self.itemModels.firstIndex(where: { $0.persistentItem == item }),
                       self.itemModels[existingModelIndex].validationState != .notChecked {
                        validationState = self.itemModels[existingModelIndex].validationState
                    } else {
                        validationState = .notChecked
                    }
                default:
                    validationState = .notChecked
                }

                return DownloadItemModel(persistentItem: item, video: video, validationState: validationState)
            }

            DispatchQueue.main.async {
                self.itemModels = items
                self.collectionView.reloadData()
            }
        }
    }

    private weak var footerView: DownloadsCollectionFooter?
    private func updateFooter() {
        DownloadService.shared.getFreeSpace { description in
            DispatchQueue.main.async {
                self.footerView?.updateText(description)
            }
        }
    }

    private func configureButtons() {
        navigationItem.rightBarButtonItems = [
            configureValidateButton(),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            configurePauseButton(),
        ]
    }

    private func configureValidateButton() -> UIBarButtonItem {
        guard isValidationInProgress else {
            return UIBarButtonItem(
                image: UIImage(systemName: "stethoscope", withConfiguration: UIImage.SymbolConfiguration(scale: .large)),
                style: .plain,
                target: self,
                action: #selector(validateButtonAction)
            )
        }

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        let validationItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        return validationItem
    }

    private func configurePauseButton() -> UIBarButtonItem {
        UIBarButtonItem(
            barButtonSystemItem: downloadsPaused ? .play : .pause,
            target: self,
            action: #selector(pauseButtonAction)
        )
    }

    private var downloadsPaused = false {
        didSet {
            configureButtons()
            if downloadsPaused {
                DownloadService.shared.pauseDownloads()
            } else {
                DownloadService.shared.resumeDownloads()
            }
        }
    }

    @objc
    private func pauseButtonAction() {
        downloadsPaused.toggle()
    }

    @objc
    private func validateButtonAction() {
        guard hasItems else {
            configureButtons()
            return
        }

        DownloadService.shared.validateAll()
        isWaitingValidation = true
    }

    private var isWaitingValidation = false {
        didSet {
            configureButtons()
        }
    }
}

// MARK: - Data Source

extension DownloadsController {

    var hasItems: Bool {
        !itemModels.isEmpty
    }

    var isValidationInProgress: Bool {
        isWaitingValidation || DownloadService.shared.hasValidatingItems
    }
}

// MARK: - UICollectionViewDataSource

extension DownloadsController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemModels.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DownloadsCollectionCell.reuseId, for: indexPath) as! DownloadsCollectionCell
        cell.update(with: itemModels[indexPath.item])
        return cell
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DownloadsCollectionFooter.reuseId,
                for: indexPath
            ) as? DownloadsCollectionFooter
            guard let footer else {
                return UICollectionReusableView()
            }

            footerView = footer
            updateFooter()
            return footer
        }

        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate

extension DownloadsController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = itemModels[indexPath.item]
        PlayerView.showFullscreen(model.video, on: self, fromTime: nil, completion: { playerView in
            playerView.delegate = self
        })
    }
}

// MARK: - PersistenceManagerListener

extension DownloadsController: PersistenceManagerListener {
    func persistenceManager(_ manager: PersistenceManager, didFailWithError error: Error) {
        updateDataSource()
        updateFooter()
    }

    func persistenceManager(_ manager: PersistenceManager, added item: PersistentItem) {
        updateDataSource()
        updateFooter()
    }

    func persistenceManager(_ manager: PersistenceManager, removed item: PersistentItem) {
        updateDataSource()
        updateFooter()
    }

    func persistenceManager(_ manager: PersistenceManager, updatedStatusOf item: PersistentItem) {
        updateValidationState(for: item, manager: manager)
        if manager.state(of: item).downloadState == .finished {
            updateFooter()
        }
    }

    func persistenceManager(_ manager: PersistenceManager, didValidateItem item: PersistentItem, error: Error?) {
        updateValidationState(for: item, validationResult: error == nil)
        updateFooter()
        isWaitingValidation = DownloadService.shared.hasValidatingItems
    }
}

// MARK: - Validation in UI

private extension DownloadsController {

    func updateValidationState(for item: PersistentItem, validationResult: Bool) {
        guard let index = itemModels.firstIndex(where: { $0.persistentItem == item }) else {
            return
        }

        let validationState: DownloadItemModel.ValidationState = validationResult ? .valid : .invalid
        let video = itemModels[index].video
        itemModels[index] = DownloadItemModel(
            persistentItem: item,
            video: video,
            validationState: validationState
        )
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.reloadItems(at: [indexPath])
    }

    func updateValidationState(for item: PersistentItem, manager: PersistenceManager) {
        guard let index = itemModels.firstIndex(where: { $0.persistentItem == item }) else {
            return
        }

        let state = manager.state(of: item)
        let validationState = state.validationState
        let video = itemModels[index].video
        itemModels[index] = DownloadItemModel(
            persistentItem: item,
            video: video,
            validationState: validationState == .processing ? .checking : .notChecked
        )
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.reloadItems(at: [indexPath])
    }
}

extension DownloadsController: PlayerDelegate {

    func player(_ playerView: OVKit.PlayerView, reloadVideoWithCompletionHandler completionHandler: @escaping ((any OVKit.VideoType)?) -> Void) {
        playerView.video = playerView.video
    }

    func player(_ playerView: OVKit.PlayerView, unlockRestrictedVideo video: any OVKit.VideoType, withCompletionHandler completionHandler: @escaping ([Int]?, Date?, (any Error)?) -> Void) {}
}
