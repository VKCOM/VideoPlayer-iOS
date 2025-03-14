import UIKit
import OVKit


extension ControlMask {

    static func demoControlMask() -> ControlMask {
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

        var mask = Set<ControlValue>()
        mask.insert(.adSurface)
        mask.insert(.sparked)
        mask.insert(.pause(paused: paused))
        mask.insert(.sound(enabled: soundOn, restricted: restricted))

        if let time = currentTime {
            mask.insert(.playhead(seconds: time))
        }
        if let duration = duration {
            mask.insert(.duration(seconds: duration))
        }
        if let cta = cta {
            let data = CTAData(title: cta.text, text: cta.ctaText, icon: cta.icon, iconUrl: cta.iconUrlString, color: cta.ctaTextColor, backgroundColor: cta.ctaBackgroundColor)
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
        } else if let videoMotionPlayer = videoMotionPlayer {
            if let banner = videoMotionPlayer.banner {
                mask.insert(.adInteractive(banner: .videoMotion(banner: banner)))
            } else {
                assertionFailure("Video Motion player must be presented at this point!")
            }
        }
        return ControlMask(controls: mask)
    }
}


final class FullscreenAdsControlsViewController: UIViewController {

    private var controlMask: ControlMask {
        .demoControlMask()
    }


    private var controlsView: FullscreenSupplementedAdControlsView?


    override func loadView() {
        super.loadView()

        let controlsBounds: CGRect = if view.bounds.width > 0 {
            .init(
                origin: .zero,
                size: .init(width: view.bounds.width, height: view.bounds.width * 9 / 16)
            )
        } else {
            .zero
        }

        controlsView = FullscreenSupplementedAdControlsView.createInstance(frame: controlsBounds)
        if let controlsView {
            controlsView.controlMask = controlMask
            controlsView.hideControls(animated: false)
            controlsView.backgroundColor = .lightGray
            view.addSubview(controlsView)
        }
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        controlsView?.frame = view.bounds
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

        let types:[UIView & PlayerControlsViewProtocol] = [
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
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        stackView.frame = view.bounds.inset(by: view.safeAreaInsets)
    }


    // MARK: Present Fullscreen


    func createFullscreenNavigationItem() -> UIBarButtonItem {
        UIBarButtonItem.init(image: UIImage.init(systemName: "arrow.up.left.and.arrow.down.right"), style: .plain, target: self, action: #selector(presentFullscreenAdsControlsViewController))
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
