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

    func downloadVideo(_ video: VideoType, quality: Int = 1080, useHLS: Bool = false, onlySound: Bool = false) {
        downloader.downloadVideo(video, inQuality: quality, useHLS: useHLS, onlySound: onlySound, userData: nil)
    }

    func delete(item: PersistentItem) {
        downloader.cancelOrDeleteItem(item)
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

    func validateAll() {
        downloader.validateAll()
    }

    var hasValidatingItems: Bool {
        !downloader.getItemsWithStates {
            $0.validationState == .processing
        }
        .isEmpty
    }

    func clearLocalURLs(for video: VideoType) {
        for format in VideoFileFormat.allCases where video.videoURL(format)?.isFileURL == true {
            video.setVideoURL(nil, for: format)
        }
    }

    func fillLocalURLs(for video: VideoType) {
        guard let item = items.first(where: {
            $0.identifier == video.videoId
                && getState(of: $0).downloadState == .finished
                && !$0.onlySound
        }) else {
            return
        }

        let localVideo = getVideo(of: item, forLocalPlayback: true)

        guard let sourceURL = localVideo.videoURL(.source) else {
            return
        }

        video.setVideoURL(sourceURL, for: .source)

        if let format = VideoFileFormat(rawValue: "mp4_\(item.quality)") {
            video.setVideoURL(sourceURL, for: format)
        }
    }
}
