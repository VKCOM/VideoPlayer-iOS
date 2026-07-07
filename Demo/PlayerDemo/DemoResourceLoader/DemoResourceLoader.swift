//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import AVFoundation
import Foundation
import UniformTypeIdentifiers

/// Схема URL, которую перехватывает DemoResourceLoader.
///
/// Чтобы AVAssetResourceLoader вызывал методы делегата, URL в VideoType должен использовать
/// именно эту схему вместо стандартных http/https. Внутри делегата схема восстанавливается обратно.
private let demoResourceLoaderScheme = "ovkdemo"

/// Демо-реализация AVAssetResourceLoaderDelegate с поддержкой локального кеша.
///
/// Если `localFileURL` установлен — отвечает байтами из локального файла.
/// Иначе скачивает из сети через URLSession.
///
final class DemoResourceLoader: NSObject, AVAssetResourceLoaderDelegate {
    /// Локальный MP4-файл для отдачи вместо сетевой загрузки.
    /// Установить необходимо до начала воспроизведения. Если nil — данные качаются из сети.
    var localFileURL: URL?

    private var activeTasks: [ObjectIdentifier: URLSessionDataTask] = [:]
    private let tasksLock = NSLock()

    // MARK: - AVAssetResourceLoaderDelegate

    func resourceLoader(
        _ resourceLoader: AVAssetResourceLoader,
        shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest
    ) -> Bool {
        guard let requestURL = loadingRequest.request.url,
              var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false) else {
            return false
        }

        components.scheme = "https"
        guard let originalURL = components.url else {
            loadingRequest.finishLoading(with: NSError(domain: "DemoResourceLoader", code: -1))
            return false
        }

        if let fileURL = localFileURL {
            serveFromLocalFile(fileURL, loadingRequest: loadingRequest)
        } else {
            downloadFromNetwork(originalURL: originalURL, loadingRequest: loadingRequest)
        }

        return true
    }

    func resourceLoader(
        _ resourceLoader: AVAssetResourceLoader,
        didCancel loadingRequest: AVAssetResourceLoadingRequest
    ) {
        let key = ObjectIdentifier(loadingRequest)
        tasksLock.lock()
        let task = activeTasks.removeValue(forKey: key)
        tasksLock.unlock()
        task?.cancel()
    }

    private func serveFromLocalFile(
        _ fileURL: URL,
        loadingRequest: AVAssetResourceLoadingRequest
    ) {
        if let infoRequest = loadingRequest.contentInformationRequest {
            let attrs = try? FileManager.default.attributesOfItem(atPath: fileURL.path)
            infoRequest.contentLength = (attrs?[.size] as? NSNumber)?.int64Value ?? 0
            infoRequest.contentType = UTType.mpeg4Movie.identifier
            infoRequest.isByteRangeAccessSupported = true
        }

        if let dataRequest = loadingRequest.dataRequest {
            do {
                let fileHandle = try FileHandle(forReadingFrom: fileURL)
                defer { try? fileHandle.close() }

                let offset = dataRequest.requestedOffset
                let length = dataRequest.requestedLength

                try fileHandle.seek(toOffset: UInt64(offset))
                let data = fileHandle.readData(ofLength: length)
                dataRequest.respond(with: data)
            } catch {
                loadingRequest.finishLoading(with: error)
                return
            }
        }

        loadingRequest.finishLoading()
    }

    private func downloadFromNetwork(
        originalURL: URL,
        loadingRequest: AVAssetResourceLoadingRequest
    ) {
        let task = URLSession.shared.dataTask(with: originalURL) { data, response, error in
            if let error {
                loadingRequest.finishLoading(with: error)
                return
            }

            if let response = response as? HTTPURLResponse {
                loadingRequest.response = response
            }

            if let data {
                loadingRequest.dataRequest?.respond(with: data)
            }

            loadingRequest.finishLoading()
        }

        let key = ObjectIdentifier(loadingRequest)
        tasksLock.lock()
        activeTasks[key] = task
        tasksLock.unlock()

        task.resume()
    }
}

// MARK: - URL helpers

extension URL {
    /// Заменяет схему URL на `demoResourceLoaderScheme`.
    var withDemoResourceLoaderScheme: URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.scheme = demoResourceLoaderScheme
        return components?.url
    }
}
