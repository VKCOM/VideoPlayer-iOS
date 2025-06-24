import UIKit
import OVKit


class FeedVideoModel: CustomStringConvertible {
    
    let item: Video
    
    init(item: Video) {
        self.item = item
    }
    
    var description: String {
        return "VideoModel: \(item)"
    }
}


// MARK: - PrefetchItem

extension FeedVideoModel: PrefetchItem {
        
    var prefetchMinTime: TimeInterval {
        item.prefetchMinTime
    }
    
    var prefetchResource: VideoType {
        item
    }
    
    var prefetchQualityRangeCellular: QualityRange {
        item.prefetchQualityRangeCellular
    }
    
    var prefetchQualityRangeWiFi: QualityRange {
        item.prefetchQualityRangeWiFi
    }
    
    var prefetchPreviews: [ImageAssetType] {
        item.previewImages
    }

    var prefetchThumbnails: [ImageAssetType] {
        item.prefetchThumbnails
    }
}
