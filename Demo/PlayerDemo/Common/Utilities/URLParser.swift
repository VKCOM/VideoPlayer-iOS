//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit

final class URLParser {
    private(set) var vkVideoId: String?
    private(set) var isLive = false
    private(set) var rawUrl: (format: VideoFileFormat?, url: URL)?

    func parseURL(_ string: String) {
        vkVideoId = nil
        rawUrl = nil
        isLive = false

        guard let url = URL(string: string) else {
            return
        }

        if url.isFileURL {
            rawUrl = (VideoFileFormat.source, url)
            return
        }

        if let host = url.host?.lowercased(), host.hasSuffix("vk.com") || host.hasSuffix("vk.ru") || host.hasSuffix("vkvideo.ru") {
            let path = url.lastPathComponent.lowercased()
            var template: String?
            if path.starts(with: "video") {
                template = "video"
            }
            if path.starts(with: "clip") {
                template = "clip"
            }
            if let template {
                let videoId = path.replacingOccurrences(of: template, with: "")
                if !videoId.isEmpty {
                    vkVideoId = videoId
                    return
                }
            }
        }

        if string.contains("ct=0") {
            rawUrl = (.mp4_1080, url)
            return
        }
        if string.contains("ct=8") {
            rawUrl = (.hls, url)
            return
        }
        if string.contains("ct=6") {
            let mapping: [Int: VideoFileFormat] = [
                0: .dashHevc,
                1: .dashSep,
                4: .dashWebm,
                5: .dashWebmAv1,
                6: .dashStreams
            ]
            if let fmt = mapping.first(where: { key, _ in
                string.contains("type=\(key)")
            })
            .map(\.value) {
                rawUrl = (fmt, url)
                return
            } else {
                rawUrl = (.dashSep, url)
            }
        }
        if string.contains("/ondemand/") {
            rawUrl = (.dashSep, url)
            return
        }
        if string.contains("/hls/") {
            if string.contains("_offset_p.") {
                rawUrl = (.hlsLivePlayback, url)
            } else {
                rawUrl = (.hlsLive, url)
            }
            isLive = true
            return
        }
        if string.contains("/cmaf/") || string.contains("/live.prod/") || string.contains("/live.test/") {
            rawUrl = (.dashCmaf, url)
            return
        }
        if string.contains("rtmp://") {
            rawUrl = (.rtmp, url)
            return
        }
        rawUrl = (nil, url)
    }

    func makeVideo() -> Video? {
        if let vkVideoId {
            return Video(id: vkVideoId)
        }
        if let rawUrl, let format = rawUrl.format {
            let video = Video(id: "0_0")
            video.files[format] = rawUrl.url
            video.liveStatus = isLive ? .started : .unknown
            return video
        }
        return nil
    }

    func correctFormat(_ format: VideoFileFormat) {
        guard let rawUrl, rawUrl.format != format else {
            return
        }

        self.rawUrl = (format, rawUrl.url)
    }
}
