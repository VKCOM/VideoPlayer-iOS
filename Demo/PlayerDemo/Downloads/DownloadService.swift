//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import Foundation
import OVKit

class DownloadService {
    private let accessLock = NSLock()

    lazy var _downloader: PersistenceManager = {
        let libraryUrl = try! FileManager.default
            .url(
                for: .libraryDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            .appendingPathComponent("one.video.offline")
        let config = PersistenceManagerConfig(libraryRoot: libraryUrl, allowedNetworkType: .wifiAndCellular(), maxConcurrentDownloadsCount: OperationQueue.defaultMaxConcurrentOperationCount)
        return PersistenceManager(with: config, listenerQueue: .main)
    }()

    private var downloader: PersistenceManager {
        accessLock.lock()
        defer { accessLock.unlock() }

        return _downloader
    }

    private init() {}

    // MARK: - Public

    static let shared = DownloadService()

    func getFreeSpace(_ completion: @escaping (String) -> Void) {
        downloader.calculateAvailableDiskSpace { availableSpace in
            self.downloader.calculateLibraryDiskSize { librarySize in
                let availableSpaceString = "\(availableSpace / 1024 / 1024)MB"
                let librarySizeString = "\(librarySize / 1024 / 1024)MB"

                completion("Library \(librarySizeString) / Available \(availableSpaceString)")
            }
        }
    }

    func downloadVideo(_ video: VideoType) {
        let useHLS = SettingsViewController.useHLS
        downloader.downloadVideo(video, inQuality: 1080, useHLS: useHLS, onlySound: false, userData: nil)
    }

    func deleteVideo(_ video: VideoType) {
        downloader.cancelOrDeleteVideo(video)
    }

    func getState(of item: PersistentItem) -> PersistentItemState {
        downloader.state(of: item) // Немного блокирующий вызов может быть
    }

    func getVideo(of item: PersistentItem, forLocalPlayback: Bool = false) -> Video {
        downloader.video(of: item, forLocalPlayback: forLocalPlayback)
    }

    func hasVideo(_ video: VideoType) -> Bool {
        downloader.hasVideo(video) // Немного блокирующий вызов может быть
    }

    var items: [PersistentItem] {
        downloader.items // Немного блокирующий вызов может быть
    }

    func addListener(_ listener: PersistenceManagerListener) {
        downloader.addListener(listener)
    }

    func removeListener(_ listener: PersistenceManagerListener) {
        downloader.removeListener(listener)
    }

    func clearCurrentUser() {
        downloader.clearUserLibrary()
    }

    func clearAllData() {
        downloader.clearAllData()
    }

    func pauseDownloads() {
        downloader.isManuallySuspended = true
    }

    func resumeDownloads() {
        downloader.isManuallySuspended = false
    }
}
