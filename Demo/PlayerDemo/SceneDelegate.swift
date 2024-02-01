import UIKit
import OVKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .semibold)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .semibold)], for: .normal)
        
        window = UIWindow(windowScene: windowScene)
        window!.frame = windowScene.coordinateSpace.bounds
        window!.rootViewController = TabbarController()
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
        return Self.findTopViewController(base: window!.rootViewController)
    }
    
    func customPiPControls(with frame: CGRect) -> UIView {
        return PiPCustomControls(frame: frame)
    }
    
    func playerView(_ fromPlayerView: OVKit.PlayerView, willShowPiP pip: OVKit.PiPWindow) {
    }
    
    
    func playerView(_ fromPlayerView: OVKit.PlayerView?, willShowFullscreen fullscreenController: OVKit.FullscreenContentController) -> OVKit.FullscreenController? {
        // Принудительное включение звука
        fromPlayerView?.soundOn = true
        fullscreenController.alwaysShowSoundButton = true

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


    func pipWindow(_ pip: PiPWindow, restoreUserInterfaceForPipMaximizeWithCompletionHandler completionHandler: @escaping (PlayerView?) -> Void) {
        completionHandler(nil)
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
            return findTopViewController(base: nav.visibleViewController)
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
