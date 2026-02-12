//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import UIKit

class ViewController: UIViewController {
    private var appearanceCount: UInt = 0

    var isFirstAppearance: Bool {
        appearanceCount <= 1
    }

    private var activityIndicator: UIActivityIndicatorView?

    private var errorLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        appearanceCount += 1
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let safeFrame = view.bounds.inset(by: view.safeAreaInsets)

        if let activityIndicator {
            activityIndicator.center = CGPoint(x: safeFrame.midX, y: safeFrame.midY)
        }

        if let errorLabel {
            var size = errorLabel.sizeThatFits(CGSize(width: safeFrame.width - 32, height: safeFrame.height))
            size = CGSize(width: ceil(size.width), height: ceil(size.height))
            errorLabel.frame = CGRect(x: safeFrame.midX - round(size.width / 2), y: safeFrame.midY - round(size.height / 2), width: size.width, height: size.height)
        }
    }

    func startActivity() {
        hideError()
        guard activityIndicator == nil else {
            return
        }

        activityIndicator = UIActivityIndicatorView(style: .medium)
        view.addSubview(activityIndicator!)
        activityIndicator!.startAnimating()
    }

    func stopActivity() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }

    func showError(_ message: String) {
        if let errorLabel {
            errorLabel.text = message
            view.setNeedsLayout()
            return
        }

        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = message
        errorLabel = label
        view.addSubview(label)
        view.setNeedsLayout()
    }

    func hideError() {
        errorLabel?.removeFromSuperview()
        errorLabel = nil
    }

    func loadVideo(_ video: Video, for playerView: PlayerView, completion: ((Bool) -> Void)? = nil) {
        if video.haveVideoFiles {
            playerView.video = video
            stopActivity()
            completion?(true)
            return
        }

        playerView.isHidden = true
        startActivity()
        ApiSession.shared?.fetch(videoIds: [video.videoId]) { [weak self] videos, error in
            DispatchQueue.main.async {
                guard let self else {
                    completion?(false)
                    return
                }

                self.stopActivity()
                if let error {
                    self.showError(error.localizedDescription)
                    completion?(false)
                    return
                }
                guard let video = videos?.first else {
                    self.showError("Something went wrong")
                    completion?(false)
                    return
                }

                playerView.isHidden = false
                playerView.video = video
                completion?(true)
            }
        }
    }
}

// MARK: - PlayerDelegate

extension ViewController: PlayerDelegate {
    func player(_ playerView: PlayerView, reloadVideoWithCompletionHandler completionHandler: @escaping (VideoType?) -> Void) {
        guard let apiSession = ApiSession.shared else {
            assertionFailure("Can nether play the video nor fetch by id. Initialize API Session first.")
            return
        }
        guard let videoId = playerView.video?.videoId else {
            return
        }

        apiSession.fetch(videoIds: [videoId]) { [weak self] videos, error in
            DispatchQueue.main.async {
                guard self != nil else {
                    completionHandler(nil)
                    return
                }

                if let error {
                    print("Fetch video error:", error)
                    completionHandler(nil)
                    return
                }
                guard let video = videos?.first else {
                    completionHandler(nil)
                    return
                }

                completionHandler(video)
            }
        }
    }

    func player(_ playerView: PlayerView, unlockRestrictedVideo video: VideoType, withCompletionHandler completionHandler: @escaping ([Int]?, Date?, Error?) -> Void) {
        completionHandler(nil, nil, nil)
    }
}

class TableController: UITableViewController {
    private var appearanceCount: UInt = 0

    var isFirstAppearance: Bool {
        appearanceCount <= 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .clear
        view.backgroundColor = .systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        appearanceCount += 1
    }
}

class CollectionController: UICollectionViewController {
    private var appearanceCount: UInt = 0

    var isFirstAppearance: Bool {
        appearanceCount <= 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .clear
        view.backgroundColor = .systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        appearanceCount += 1
    }
}
