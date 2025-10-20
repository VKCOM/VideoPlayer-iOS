//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import UIKit

class ViewResizer: NSObject, UIGestureRecognizerDelegate {
    var isEnabled = false {
        didSet {
            panGesture.isEnabled = isEnabled
        }
    }

    func activate() {
        panEnablingGesture.isEnabled = true
    }

    var minHeight: CGFloat = 0.0
    var minWidth: CGFloat = 0.0

    init(with view: UIView) {
        self.view = view
        super.init()
        self.view.addGestureRecognizer(panGesture)
        self.beganFrame = view.frame
        self.view.addGestureRecognizer(panEnablingGesture)
    }

    // MARK: Private

    private let view: UIView

    private lazy var panGesture = {
        let gesture = UIPanGestureRecognizer()
        gesture.delegate = self
        gesture.addTarget(self, action: #selector(pan(_:)))
        gesture.isEnabled = true
        return gesture
    }()

    private lazy var panEnablingGesture = {
        let gesture = UITapGestureRecognizer()
        gesture.delegate = self
        gesture.numberOfTapsRequired = 2
        gesture.addTarget(self, action: #selector(togglePan(_:)))
        return gesture
    }()

    private var beganFrame = CGRect.zero

    @objc
    private func togglePan(_ gesture: UIPanGestureRecognizer) {
        isEnabled.toggle()
    }

    @objc
    private func pan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }

        switch gesture.state {
        case .possible: break
        case .began: beganFrame = view.frame
        case .changed,
             .cancelled,
             .ended,
             .failed:
            let translation = gesture.translation(in: gesture.view?.superview)
            view.frame = .init(
                origin: beganFrame.origin,
                size: .init(
                    width: max(minWidth, beganFrame.width + translation.x),
                    height: max(minHeight, beganFrame.height + translation.y)
                )
            ).integral
        @unknown default:
            break
        }
    }

    // MARK: UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
