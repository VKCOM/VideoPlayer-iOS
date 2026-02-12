//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import UIKit

class AppCoordinator {
    static let shared = AppCoordinator()
    var initialVideoURL: String?
    private var initialTab = AppTab.single

    private init() {}

    func readEnvironmentParams() {
        initialVideoURL = ProcessInfo.processInfo.environment["DEMO_INITIAL_VIDEO_URL"]

        if let tabString = ProcessInfo.processInfo.environment["DEMO_INITIAL_TAB"] {
            initialTab = AppTab(rawValue: tabString) ?? .single
        }
    }

    func createInitialController() -> UIViewController {
        if initialTab == .uiTest {
            let vc = CustomController()
            return UINavigationController(rootViewController: vc)
        }

        let tabbarController = TabbarController()
        tabbarController.selectedIndex = initialTab.tabIndex ?? 0
        return tabbarController
    }
}

private enum AppTab: String, CaseIterable {
    case single
    case feed
    case transitions
    case multiplay
    case uiTest = "uitest"

    var tabIndex: Int? {
        self == .uiTest ? nil : Self.allCases.firstIndex(of: self)
    }
}
