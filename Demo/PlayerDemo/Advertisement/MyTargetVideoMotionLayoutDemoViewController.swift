import UIKit

#if canImport(OVKitMyTargetPlugin)
import OVKitMyTargetPlugin


class MyTargetVideoMotionLayoutDemoViewController: UIViewController {
    
    private let duration: Double = 10
    private lazy var cardsView = MyTargetPluginImpl().createVideoMotionView(frame: .zero, currentTime: 0, duration: duration)


    private lazy var viewResizer = {
        let vR = ViewResizer(with: cardsView)
        vR.minHeight = 180
        vR.minWidth = 320
        return vR
    }()


    private lazy var tapsCounter: TapsCounter = {
        TapsCounter(maxCount: Int(duration)) { [weak self] in
            guard let self else { return }
            cardsView.update(currentTime: Double(tapsCounter.count ?? 0), duration: duration)
        }
    }()


    override func loadView() {
        super.loadView()
        title = "Video Motion"
//        viewResizer.activate()
        view.addSubview(cardsView)
        tapsCounter.beginCountTaps(on: cardsView)
        layoutCardsView()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }


    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            guard let self else { return }
            layoutCardsView()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: Mock the banner for debug
        cardsView.show(banner: nil)
    }

    // MARK: Private

    func layoutCardsView() {
        cardsView.frame = view.bounds
//        layoutCardsViewFixed()
//        layoutCardsViewSafeArea()
    }


    func layoutCardsViewFixed() {
        cardsView.frame = CGRect(x: 100, y: 100, width: 430, height: 250)
    }


    func layoutCardsViewSafeArea() {
        cardsView.frame = CGRect(x: view.safeAreaInsets.left,
                                 y: view.safeAreaInsets.top,
                                 width: view.bounds.width - view.safeAreaInsets.left  - view.safeAreaInsets.right,
                                 height: view.bounds.height - view.safeAreaInsets.top  - view.safeAreaInsets.bottom).integral
    }
}

#endif
