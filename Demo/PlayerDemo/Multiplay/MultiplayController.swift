//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import OVKResources
import UIKit

class MultiplayController: ViewController {
    var multiPlayers = [PlayerView]()
    var multiIndicators = [UIImageView]()
    var regularPlayer: PlayerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Multiplay"
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
    }

    @objc
    private func handleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: view)
        for multiPlayer in multiPlayers {
            guard multiPlayer.frame.contains(point) else {
                continue
            }

            if multiPlayer.isPlaybackActive, multiPlayer.soundOn {
                // достаточно выключить звук, и плеер перестанет быть активным
                multiPlayer.soundOn = false
            } else {
                multiPlayer.play(userInitiated: true)
                multiPlayer.soundOn = true
            }
            break
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        func playIfNeeded() {
            regularPlayer?.playerViewOnScreen = true
            for multiPlayer in multiPlayers {
                multiPlayer.playerViewOnScreen = true
                multiPlayer.play(userInitiated: false)
            }
        }

        if isFirstAppearance {
            loadVideos {
                playIfNeeded()
            }
        } else {
            playIfNeeded()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        regularPlayer?.playerViewOnScreen = false
        for multiPlayer in multiPlayers {
            multiPlayer.playerViewOnScreen = false
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let regularPlayer else {
            return
        }

        let safeFrame = view.bounds.inset(by: view.safeAreaInsets)
        let frames = Self.calculateFrames(into: safeFrame)

        for i in 0..<multiPlayers.count {
            multiPlayers[i].frame = frames[i]
            multiIndicators[i].center = CGPoint(x: frames[i].maxX, y: frames[i].minY)
        }
        regularPlayer.frame = frames[4]
    }

    private func loadVideos(_ completion: @escaping () -> Void) {
        startActivity()
        ApiSession.shared?.fetch(ownerVideos: "-26006257", count: 20) { [weak self] items, error in
            DispatchQueue.main.async {
                guard let self else {
                    return
                }

                self.stopActivity()

                let videos = items?.filter { $0.haveVideoFiles }
                guard let videos, videos.count >= 5 else {
                    self.showError(error?.localizedDescription ?? "Something went wrong")
                    return
                }

                for i in 0..<4 {
                    self.setupPlayer(video: videos[i], multi: true)
                }
                self.setupPlayer(video: videos[4], multi: false)

                completion()
            }
        }
    }

    func player(_ playerView: PlayerView, didMute muted: Bool, userInitiated: Bool) {
        guard playerView.allowsMultiplay else {
            return
        }

        multiIndicators[playerView.tag].image = muted ? .ovk_soundOff48 : .ovk_soundOn48
    }

    private func setupPlayer(video: VideoType, multi: Bool) {
        #if OLD_ADS_OFF
        let player = PlayerView(frame: .zero, gravity: .fill, controls: InplaceCustomControls(frame: .zero))
        #else
        let player = PlayerView(frame: .zero, gravity: .fill, customControls: InplaceCustomControls(frame: .zero))
        #endif
        player.delegate = self
        // view маленького размера, поэтому нет смысла загружать более высокое качество
        player.autoQualityRange = QualityRange(sameOrWorseThan: 360)
        player.layer.cornerRadius = 10
        video.repeated = true
        player.video = video
        if multi {
            player.tag = multiPlayers.count
            multiPlayers.append(player)
            player.allowsMultiplay = true
            player.accessibilityIdentifier = "video_player.multiplay"
            player.isUserInteractionEnabled = false
        } else {
            regularPlayer = player
            player.accessibilityIdentifier = "video_player.regular"
        }
        view.addSubview(player)

        if multi {
            let indicator = UIImageView(image: .ovk_soundOff48)
            indicator.layer.anchorPoint = CGPoint(x: 1, y: 0)
            multiIndicators.append(indicator)
            view.addSubview(indicator)
        }
    }

    private static func calculateFrames(into viewFrame: CGRect) -> [CGRect] {
        var frames = [CGRect]()
        let padding: CGFloat = 12
        if viewFrame.height > viewFrame.width {
            let smallWidth = floor((viewFrame.width - 3 * padding) / 2)
            let smallHeight = ceil(smallWidth * 9 / 16)
            let bigWidth = smallWidth * 2 + padding
            let bigHeight = ceil(bigWidth * 9 / 16)
            let allHeight = smallHeight * 2 + padding * 2 + bigHeight
            let y = viewFrame.origin.y + round((viewFrame.height - allHeight) / 2)
            frames.append(CGRect(x: viewFrame.origin.x + padding, y: y, width: smallWidth, height: smallHeight))
            frames.append(CGRect(x: frames[0].maxX + padding, y: y, width: smallWidth, height: smallHeight))
            frames.append(CGRect(x: frames[0].origin.x, y: frames[0].maxY + 12, width: smallWidth, height: smallHeight))
            frames.append(CGRect(x: frames[1].origin.x, y: frames[2].origin.y, width: smallWidth, height: smallHeight))
            frames.append(CGRect(x: frames[0].origin.x, y: frames[2].maxY + 12, width: bigWidth, height: bigHeight))
        } else {
            let smallHeight = floor((viewFrame.height - 4 * padding) / 3)
            let smallWidth = ceil(smallHeight * 16 / 9)
            let bigHeight = smallHeight * 2 + padding
            let bigWidth = min(ceil(bigHeight * 16 / 9), viewFrame.width - smallWidth - padding)
            let allWidth = smallWidth + padding + bigWidth
            let x = viewFrame.origin.x + round((viewFrame.width - allWidth) / 2)
            frames.append(CGRect(x: x, y: viewFrame.origin.y + padding, width: smallWidth, height: smallHeight))
            frames.append(CGRect(x: x, y: frames[0].maxY + padding, width: smallWidth, height: smallHeight))
            frames.append(CGRect(x: x, y: frames[1].maxY + padding, width: smallWidth, height: smallHeight))
            frames.append(CGRect(x: frames[0].maxX + padding, y: frames[0].origin.y, width: smallWidth, height: smallHeight))
            frames.append(CGRect(x: frames[3].origin.x, y: frames[3].maxY + padding, width: bigWidth, height: bigHeight))
        }
        return frames
    }
}
