//
//  FeedController.swift
//  PlayerDemo
//
//  Created by Oleg Adamov on 01.12.2020.
//

import UIKit
import OVKit
import os.log

class FeedController: TableController, PlayerViewProvider {
    
    private var videoModels = [FeedVideoModel]()
    private var focusTracker: FocusOfInterestTracker?
    
    private(set) var enableAutoplay = true {
        didSet {
            NotificationCenter.default.post(name: .feedAutoplayModeChanged, object: nil)
            focusTracker?.touch()
        }
    }
    
    private lazy var listPrefetcher: ListPrefetcher = {
        let prefetcher = ListPrefetcher(with: ListPrefetcherConfig())
        prefetcher.dataSource = self
        prefetcher.delegate = self
        return prefetcher
    }()
    
    /* Страницы с видео
     playstationru "-26006257"
     gif_boomer    "-117149296"
     just_vid      "-51189706"
     numbers       "-164566978"
     restriction   "-202118094"
     */
    
    /// VK Id страницы или сообщества для ленты
    private let ownerId = "-26006257"
    
    /// Количество видео в ленте
    private let feedVideosCount = 100
    
    // MARK: - Initializers
    
    init() {
        super.init(style: .plain)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Feed"
        configureAutoplayButton()
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseId)
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        
        tableView.delegate = self
        
        ApiSession.shared?.fetch(ownerVideos: ownerId,
                                    count: UInt(feedVideosCount)) { [weak self] (items, error) in
            
            guard let self = self, let items = items else { return }
            print("Received \(items.count) items")
            
            DispatchQueue.main.async {
                self.videoModels = items
                    .filter { $0.haveVideoFiles }
                    .map { FeedVideoModel(item: $0) }
                self.tableView.reloadData()
            }
        }
        
        focusTracker = FocusOfInterestTracker(with: tableView)
        focusTracker?.delegate = self
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        visibleCells.forEach { $0.playerView.playerViewOnScreen = false }
        focusTracker?.visibility = .didDisappear
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        focusTracker?.visibility = .willDisappear
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        visibleCells.forEach { $0.playerView.playerViewOnScreen = true }
        
        if isFirstAppearance {
            focusTracker?.updateFocus()
        }
        
        focusTracker?.visibility = .didAppear
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        focusTracker?.visibility = .willAppear
    }
    
    // MARK: - Private
    
    private var visibleCells: [FeedCell] {
        tableView.visibleCells.compactMap { $0 as? FeedCell }
    }
    
    
    private func openVideo(_ video: Video, from playerView: PlayerView) {
        playerView.maximizeToFullscreen()
    }
    
    private func configureAutoplayButton() {
        let title = enableAutoplay ? "Autoplay" : "Manual"
        let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(autoplayButtonAction))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc private func autoplayButtonAction() {
        enableAutoplay = !enableAutoplay
        configureAutoplayButton()
    }
    
    // MARK: - PlayerViewProvider
    
    weak var currentPlayerView: PlayerView?
    
    func didReceivePlayer() {}
}

// MARK: - UIViewControllerTransitioningDelegate

extension FeedController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let destination = presented as? PlayerViewProvider {
            return PlayerTransitionAnimator(sourcePlayerProvider: self, destinationPlayerProvider: destination)
        }
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let source = dismissed as? PlayerViewProvider {
            return PlayerTransitionAnimator(sourcePlayerProvider: source, destinationPlayerProvider: self)
        }
        
        return nil
    }
}

// MARK: - UIScrollViewDelegate

extension FeedController {
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        focusTracker?.updateFocus()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        focusTracker?.updateFocus()
    }
}

// MARK: - UITableViewViewDelegate

extension FeedController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let feedCell = cell as! FeedCell
        feedCell.willDisplay()
        focusTracker?.trackView(feedCell)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let feedCell = cell as! FeedCell
        feedCell.didEndDisplaying()
        focusTracker?.untrackView(feedCell)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var videoSize = videoModels[indexPath.row].item.size
        if videoSize == .zero {
            videoSize = CGSize(width: 1, height: 1)
        }
        let width = tableView.bounds.width
        let ratio = min(videoSize.height / videoSize.width, 1.4)
        return floor(width * ratio)
    }
}

// MARK: - UITableViewViewDataSource

extension FeedController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseId, for: indexPath) as! FeedCell
        cell.uiDelegate = self
        cell.update(with: videoModels[indexPath.item])
        return cell
    }
}


// MARK: - FeedCellUIDelegate

extension FeedController: FeedCellUIDelegate {
    
    func selectCell(model: FeedVideoModel, view: PlayerView) {
        openVideo(model.item, from: view)
    }
}

// MARK: - FocusOfInterestTrackerDelegate

extension FeedController: FocusOfInterestTrackerDelegate {
    
    func focusDidChange(to view: FocusOfInterestView?) {
        guard let view = view as? FeedCell, let model = view.model else {
            return
        }
        
        guard let index = videoModels.firstIndex(where: { $0 === model }) else {
            return
        }
        
        // Предзагрузка, начиная от позиции в фокусе
        listPrefetcher.prefetchItems(startingAt: index)
    }
}

// MARK: - ListPrefetcherDataSource

extension FeedController: ListPrefetcherDataSource {
    
    func itemsForPrefetcher(_ prefetcher: ListPrefetcher) -> [PrefetchItem] {
        return videoModels.map { $0.item }
    }
}

// MARK: - ListPrefetcherDelegate

extension FeedController: ListPrefetcherDelegate {
    
    func listPrefetcher(_ prefetcher: ListPrefetcher, didPrefetchItem item: PrefetchItem) {
        os_log("Prefetcher did prefetch item %@", log: .default, type: .info, "\(item)")
    }
}

// MARK: - Notifications

extension Notification.Name {
    static let feedAutoplayModeChanged = Notification.Name("feedAutoplayModeChanged")
}
