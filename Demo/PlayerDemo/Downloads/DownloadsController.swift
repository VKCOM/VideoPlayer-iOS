import UIKit
import OVKit


class DownloadsController: CollectionController {
    
    private var itemModels = [DownloadItemModel]()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        var height: CGFloat = 48
        height += DownloadsCollectionCell.insets.top + DownloadsCollectionCell.insets.bottom
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 36)
        super.init(collectionViewLayout: layout)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Downloads"
        
        configurePauseButton(forPause: true)
        
        collectionView.register(DownloadsCollectionCell.self, forCellWithReuseIdentifier: DownloadsCollectionCell.reuseId)
        collectionView.register(DownloadsCollectionFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: DownloadsCollectionFooter.reuseId)
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
                return DownloadItemModel(persistentItem: item, video: video)
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
    
    private func configurePauseButton(forPause: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: forPause ? .pause : .play,
                                                            target: self,
                                                            action: #selector(pauseButtonAction))
    }
    
    private var downloadsPaused = false
    @objc private func pauseButtonAction() {
        if downloadsPaused {
            downloadsPaused = false
            configurePauseButton(forPause: true)
            DownloadService.shared.resumeDownloads()
        } else {
            downloadsPaused = true
            configurePauseButton(forPause: false)
            DownloadService.shared.pauseDownloads()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DownloadsController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DownloadsCollectionCell.reuseId, for: indexPath) as! DownloadsCollectionCell
        
        cell.update(with: itemModels[indexPath.item])
        cell.uiDelegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: DownloadsCollectionFooter.reuseId,
                                                                         for: indexPath) as? DownloadsCollectionFooter
            guard let footer = footer else {
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
        PlayerView.showFullscreen(model.video, on: self, fromTime: nil)
    }
}

// MARK: - DownloadsCollectionCellUIDelegate

extension DownloadsController: DownloadsCollectionCellUIDelegate {
    
    func cancelDownload(of model: DownloadItemModel) {
        DownloadService.shared.deleteVideo(model.video)
    }
}

// MARK: - PersistenceManagerListener

extension DownloadsController: PersistenceManagerListener {
    
    func persistenceManager(_ manager: PersistenceManager, didFailWithError error: Error) {
        // Ignore
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
        if manager.state(of: item).downloadState == .finished {
            updateFooter()
        }
    }
}
