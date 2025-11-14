//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import OVKitStatistics
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .semibold)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .semibold)], for: .normal)

        window = UIWindow(windowScene: windowScene)
        window!.frame = windowScene.coordinateSpace.bounds
        window!.rootViewController = AppCoordinator.shared.createInitialController()
        window!.tintColor = UIColor(named: "tabbar_active")
        window!.makeKeyAndVisible()

        PlayerManager.shared.delegate = self
    }

    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        if previousCoordinateSpace.bounds != windowScene.coordinateSpace.bounds {
            PlayerManager.shared.pipWindow?.didUpdateCoordinateSpace()
        }
    }
}

extension SceneDelegate: PlayerManagerDelegate {
    func playerView(_ playerView: OVKit.PlayerView, presentMenu menu: OVKit.Menu) {
        guard let topController = Self.findTopViewController(base: window!.rootViewController) else {
            assertionFailure()
            return
        }

        let c = MenuController(menu: menu)
        topController.present(c, animated: true)
    }

    func topViewController() -> UIViewController? {
        Self.findTopViewController(base: window!.rootViewController)
    }

    func pictureInPictureControls(with frame: CGRect) -> UIView? {
        PiPCustomControls(frame: frame)
    }

    func fullscreenControls(for video: VideoType?, originPlayerView: PlayerView?) -> UIView? {
        FullscreenCustomControls(frame: .zero)
    }

    func playerView(_ fromPlayerView: OVKit.PlayerView, willShowPiP pip: OVKit.PiPWindow) {}

    func playerView(_ fromPlayerView: OVKit.PlayerView?, willShowFullscreen fullscreenController: OVKit.FullscreenContentViewController) -> OVKit.FullscreenController? {
        // Принудительное включение звука
        fromPlayerView?.soundOn = true

        // Полноэкранный плеер можно показать сразу с supplementary view controller
        if fromPlayerView?.demo_context?.openWithDetail == true, let video = (fromPlayerView ?? fullscreenController.playerView).video {
            let detail = DetailController(video: video)
            detail.onClose = { [weak fullscreenController] in
                fullscreenController?.setSupplementaryViewController(nil, animated: true)
            }
            fullscreenController.setSupplementaryViewController(NavigationController(rootViewController: detail), animated: true)
        }

        return nil
    }

    func makeStatHandlers(for playerView: PlayerView) -> [any StatsHandler] {
        var handlers = [StatsHandler]()

        // Если требуется отправка OneLog статистики, необходимо создать для нее хендлер.
        // guard let video = playerView.video, let handler = StatsHandlerOneLog.makeHandlerForVideo(video)
        // else {
        //     return []
        // }
        // return [handler]

        if StatsManager.shared.debugMode {
            if let video = playerView.video, let h = OVTechStatsHandler.makeHandlerForVideo(video, configuration: OVTechStatsHandler.Configuration()) {
                handlers.append(h)
            }
        }

//        let consoleHandler = StatsHandlerConsole(consolePrefix: "[stats]")
//        handlers.append(consoleHandler)

        return handlers
    }

    func pipWindow(_ pip: PiPWindow, restoreUserInterfaceForPipMaximizeWithCompletionHandler completionHandler: @escaping (PlayerView?, Bool) -> Void) {
        completionHandler(nil, true)
    }

    func pipScreenInsets(_ playerView: OVKit.PlayerView) -> UIEdgeInsets {
        var insets = window!.safeAreaInsets
        insets.top = max(insets.top, 14) + 4
        insets.bottom = max(insets.bottom, 14) + 4
        insets.left = max(insets.left, 14) + 4
        insets.right = max(insets.right, 14) + 4
        return insets
    }
}

extension SceneDelegate {
    class func findTopViewController(base: UIViewController?) -> UIViewController? {
        if let nav = base as? UINavigationController {
            if let visible = nav.visibleViewController {
                return findTopViewController(base: visible)
            }
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return findTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return findTopViewController(base: presented)
        }
        return base
    }
}
