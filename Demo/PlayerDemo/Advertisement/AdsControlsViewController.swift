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
        let needPostView = false
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
        if let duration = duration {
            mask.insert(.duration(seconds: duration))
        }
        if let cta = cta {
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
    private var container: FullscreenAdsControlsViewContainer?

    override func loadView() {
        super.loadView()
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

            controlsView = FullscreenSupplementedAdControlsView.createInstance(frame: container.bounds)
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
