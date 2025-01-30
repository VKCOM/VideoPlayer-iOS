import UIKit
import OVKit


class ImportFormatView: UIButton {
    
    var readyToApply: Bool {
        vkVideoId != nil || rawUrl != nil
    }
    
    private var vkVideoId: String?
    private var isLive = false
    private var rawUrl: (format: VideoFileFormat?, url: URL)?
    
    
    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = true
        clipsToBounds = true
        layer.cornerRadius = 7
        setTitle("Unknown", for: .normal)
        setTitleColor(.secondaryLabel, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        sizeToFit()
        frame = CGRect(x: 0, y: 0, width: bounds.width + 12, height: 28)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        guard let rawUrl, rawUrl.format != format else { return }
        self.rawUrl = (format, rawUrl.url)
        updateAppearance()
    }
    
    
    func provideText(_ string: String) {
        defer {
            updateAppearance()
        }
        
        vkVideoId = nil
        rawUrl = nil
        isLive = false
        
        guard let url = URL(string: string) else { return }
        
        if url.isFileURL {
            rawUrl = (VideoFileFormat.source, url)
            return
        }
        
        if let host = url.host?.lowercased(), (host.hasSuffix("vk.com") || host.hasSuffix("vk.ru")) {
            let path = url.lastPathComponent.lowercased()
            var template: String?
            if path.starts(with: "video") { template = "video" }
            if path.starts(with: "clip") { template = "clip" }
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
            let mapping : [Int: VideoFileFormat] = [
                0: .dashHevc,
                1: .dashSep,
                4: .dashWebm,
                5: .dashWebmAv1,
                6: .dashStreams
            ]
            if let fmt = mapping.first (where: { (key, _) in
                string.contains("type=\(key)")
            }).map(\.value) {
                rawUrl = (fmt, url)
                return
            } else {
                rawUrl = (.dashSep, url)
            }
        }
        if string.contains("/ondemand/")  {
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
    
    
    private func updateAppearance() {
        var text = "Unknown"
        var interaction = false
        if vkVideoId != nil {
            text = "VK Video"
        } else {
            interaction = true
        }
        if let format = rawUrl?.format {
            text = format.rawValue
        }
        
        guard title(for: .normal) != text else { return }
        
        let maxX = frame.maxX
        let y = frame.minY
        setTitle(text, for: .normal)
        sizeToFit()
        backgroundColor = interaction ? .quaternarySystemFill : .clear
        isUserInteractionEnabled = interaction
        frame = CGRect(x: maxX - bounds.width - 12, y: y, width: bounds.width + 12, height: 28)
    }
}
