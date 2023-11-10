import Foundation
import OVKit


// Demo Extension

extension Video {
    
    static func loadFromUserDefaults() -> Video? {
        guard let dict = UserDefaults.standard.dictionary(forKey: "single_ovk_video") as? [String: String] else { return nil }
        guard let id = dict["id"] else { return nil }
        let video = Video(id: id)
        for format in VideoFileFormat.allCases {
            if let value = dict[format.rawValue] {
                video.files[format] = URL(string: value)
            }
        }
        if dict["live"] != nil {
            video.liveStatus = .started
        }
        return video
    }
}


extension VideoType {
    
    func saveToUserDefaults() {
        var dict = ["id": videoId]
        for format in VideoFileFormat.allCases {
            dict[format.rawValue] = videoURL(format)?.absoluteString
        }
        if liveStatus == .started {
            dict["live"] = "1"
        }
        UserDefaults.standard.set(dict, forKey: "single_ovk_video")
    }
}
