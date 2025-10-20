//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import UIKit

extension ControlMask {
    static func demoControlMask(needPostView: Bool = false) -> ControlMask {
        let paused = false
        let soundOn = true
        let restricted = false
        let currentTime: Double? = 10.0
        let duration: Double? = 30.0
        let secondsToSkip: Double? = nil
        let cta: AssembleAdCallToAction? = AssembleAdCallToAction(ctaText: "Получить предложение")
        cta?.iconUrlString = ""
        cta?.text = "vk.com"
        cta?.icon = UIImage(systemName: "message.circle.fill")!.withRenderingMode(.alwaysOriginal)
        let adInfoImage: UIImage? = UIImage.ovk_infoOutline16
        let shoppableAdsItems: [OVKit.ShoppableAdsItem]? = nil
        let videoMotionPlayer: MyTargetInstreamAdVideoMotionPlayer? = nil
        let postViewData: CTAPostBannerData? = if needPostView {
            CTAPostBannerData(
                text: "Узнайте подробнее на сайте http://vk.com/feed",
                duration: 10,
                overlayViewColor: .red,
                backgroundImage: "https://random.imagecdn.app/160/90",
                aspectRatio: 16.0 / 9.0
            )
        } else {
            nil
        }
        var mask = Set<ControlValue>()
        mask.insert(.adSurface)
        mask.insert(.sparked)
        mask.insert(.pause(paused: paused))
        mask.insert(.sound(enabled: soundOn, restricted: restricted))

        if let time = currentTime {
            mask.insert(.playhead(seconds: time))
        }
        if let duration {
            mask.insert(.duration(seconds: duration))
        }
        if let cta {
            let data = CTAData(title: cta.text, text: cta.ctaText, icon: cta.icon, iconUrl: cta.iconUrlString, color: cta.ctaTextColor, backgroundColor: cta.ctaBackgroundColor, postBannerData: postViewData)
            mask.insert(.callToAction(data: data))
        }
        if let skipTime = secondsToSkip {
            mask.insert(.adSkip(seconds: skipTime))
        }
        if let image = adInfoImage {
            mask.insert(.adInfoButton(image: image, sender: nil))
        }
        if let items = shoppableAdsItems {
            mask.insert(.adInteractive(banner: .shoppable(items: items)))
        } else if let videoMotionPlayer {
            if let banner = videoMotionPlayer.banner {
                mask.insert(.adInteractive(banner: .videoMotion(banner: banner)))
            } else {
                assertionFailure("Video Motion player must be presented at this point!")
            }
        }
        return ControlMask(controls: mask)
    }
}
