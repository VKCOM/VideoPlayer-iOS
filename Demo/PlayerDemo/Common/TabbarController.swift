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
        
        guard ApiSession.shared != nil else {
            assertionFailure("Can nether play the video nor fetch by id. Initialize API Session first.")
            return
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

        viewControllers = [single, feed, transitions, multiplay, downloads, rotations]
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        selectedViewController?.supportedInterfaceOrientations ?? .all
    }
}
