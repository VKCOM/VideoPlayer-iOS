//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import OVKit
import OVKitUIComponents
import UIKit

final class FullscreenAdsControlsViewController: UIViewController {
    private var controlMask: ControlMask {
        .demoControlMask()
    }

    #if !OLD_ADS_OFF
    private var controlsView: OVKitUIComponents.FullscreenSupplementedAdControlsView?
    #endif
    private var container: FullscreenAdsControlsViewContainer?

    override func loadView() {
        super.loadView()

        title = "Ads Fullscreen"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        let controlsBounds = view.bounds

        container = FullscreenAdsControlsViewContainer(frame: controlsBounds)
        if let container {
            container.overrideUserInterfaceStyle = .dark
            container.backgroundColor = .black
            container.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(container)
            NSLayoutConstraint.activate([
                .init(item: container, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
                .init(item: container, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                .init(item: container, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
                .init(item: container, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            ])

            #if !OLD_ADS_OFF
            controlsView = OVKitUIComponents.FullscreenSupplementedAdControlsView.createInstance(frame: container.bounds)
            if let controlsView {
                controlsView.translatesAutoresizingMaskIntoConstraints = false
                controlsView.controlsContainer = container
                controlsView.controlMask = controlMask
                controlsView.hideControls(animated: false)
                controlsView.backgroundColor = .lightGray
                container.addSubview(controlsView)
                NSLayoutConstraint.activate([
                    .init(item: controlsView, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1, constant: 0),
                    .init(item: controlsView, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1, constant: 0),
                    .init(item: controlsView, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1, constant: 0),
                    .init(item: controlsView, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0),
                ])
            }
            #endif
        }
    }
}

final class AdsControlsViewController: UIViewController {
    private var controlMask: ControlMask {
        .demoControlMask()
    }

    private let stackView = UIStackView()

    override func loadView() {
        super.loadView()

        title = "Ads Controls"
        navigationItem.rightBarButtonItem = createFullscreenNavigationItem()

        if #available(iOS 18.0, *) {
            view.backgroundColor = .systemBackground.withProminence(.secondary)
        } else {
            view.backgroundColor = .systemBackground
        }

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        view.addSubview(stackView)

        let controlsBounds: CGRect = if view.bounds.width > 0 {
            .init(
                origin: .zero,
                size: .init(width: view.bounds.width, height: view.bounds.width * 9 / 16)
            )
        } else {
            .zero
        }

        #if !OLD_ADS_OFF
        let types: [UIView & PlayerControlsViewProtocol] = [
            SupplementedAdControlsView.createInstance(frame: controlsBounds),
            DiscoverSupplementedAdControlsView.createInstance(frame: controlsBounds),
            FullscreenSupplementedAdControlsView.createInstance(frame: controlsBounds),
        ]
        var i = 0
        for view in types {
            i += 1
            view.controlMask = controlMask
            view.hideControls(animated: false)
            view.backgroundColor = .lightGray
            if i % 2 != 0 {
                view.overrideUserInterfaceStyle = .dark
            }
            stackView.addArrangedSubview(view)
        }
        #endif
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        stackView.frame = view.bounds.inset(by: view.safeAreaInsets)
    }

    // MARK: Present Fullscreen

    func createFullscreenNavigationItem() -> UIBarButtonItem {
        UIBarButtonItem(image: UIImage(systemName: "arrow.up.left.and.arrow.down.right"), style: .plain, target: self, action: #selector(presentFullscreenAdsControlsViewController))
    }

    @objc
    func presentFullscreenAdsControlsViewController() {
        let viewController = createFullscreenControlsViewController()
        if let navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            present(viewController, animated: true)
        }
    }

    func createFullscreenControlsViewController() -> FullscreenAdsControlsViewController {
        FullscreenAdsControlsViewController()
    }
}
