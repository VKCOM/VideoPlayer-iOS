//
//  TabbarController.swift
//  PlayerDemo
//
//  Created by Oleg Adamov on 01.12.2020.
//

import UIKit
import OVKit

class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ApiSession.shared == nil {
            print("Can nether play the video nor fetch by id. Initialize API Session first.")
        }
        
        tabBar.unselectedItemTintColor = UIColor(named: "tabbar_inactive")
        
        let single = NavigationController(rootViewController: SingleController())
        single.tabBarItem = UITabBarItem(title: "Single", image: UIImage(systemName: "rectangle"), selectedImage: nil)
        
        let feed = NavigationController(rootViewController: FeedController())
        feed.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "rectangle.split.1x2"), selectedImage: nil)
        
        let multiplay = NavigationController(rootViewController: MultiplayController())
        multiplay.tabBarItem = UITabBarItem(title: "Multiplay", image: UIImage(systemName: "rectangle.split.3x3"), selectedImage: nil)
        
        let transitions = NavigationController(rootViewController: TransitionsController())
        transitions.tabBarItem = UITabBarItem(title: "Transitions", image: UIImage(systemName: "rectangle.2.swap"), selectedImage: nil)

        let downloads = NavigationController(rootViewController: DownloadsController())
        downloads.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.to.line"), selectedImage: nil)
        
        let rotations = RotationsNavController(rootViewController: RotationsController())
        rotations.tabBarItem = UITabBarItem(title: "Rotations", image: UIImage(systemName: "rotate.left"), selectedImage: nil)

#if canImport(OVKitMyTargetPlugin)
        let videoMotion = NavigationController(rootViewController: MyTargetVideoMotionLayoutDemoViewController())
        videoMotion.tabBarItem = UITabBarItem(title: "Video Motion", image: UIImage(systemName: "play.tv"), selectedImage: nil)
        let adsControls = NavigationController(rootViewController: AdsControlsViewController())
        adsControls.tabBarItem = UITabBarItem(title: "Ads Controls", image: UIImage(systemName: "rectangle.and.hand.point.up.left.filled"), selectedImage: nil)
        let adsSupplementary = NavigationController(rootViewController: UIViewController())
        adsSupplementary.tabBarItem = UITabBarItem(title: "Ads Supplementary", image: UIImage(systemName: "plus.app"), selectedImage: nil)
        let fullscreenAds = FullscreenAdsControlsViewController()
        fullscreenAds.tabBarItem = UITabBarItem(title: "Ads Fullscreen", image: UIImage(systemName: "arrow.up.left.and.arrow.down.right"), selectedImage: nil)
#else
        let videoMotion: NavigationController? = nil
        let adsControls: NavigationController? = nil
        let adsSupplementary: NavigationController? = nil
        let fullscreenAds: NavigationController? = nil
#endif

        let settings = NavigationController(rootViewController: SettingsViewController(rootView: SettingsView()))
        settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: nil)

        viewControllers = [single, feed, transitions, multiplay, downloads, rotations, videoMotion, adsControls, adsSupplementary, fullscreenAds, settings].compactMap { $0 }
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        selectedViewController?.supportedInterfaceOrientations ?? .all
    }
}
