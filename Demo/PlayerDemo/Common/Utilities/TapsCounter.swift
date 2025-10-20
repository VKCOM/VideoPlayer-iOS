//
//  Copyright © 2024 - present, VK. All rights reserved.
//

import UIKit

protocol Counter {
    var count: Int? { get }
}

class TapsCounter: Counter {
    var count: Int? {
        didSet {
            handler()
        }
    }

    func beginCountTaps(on view: UIView) {
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func endCountTaps(on view: UIView) {
        view.removeGestureRecognizer(tapGestureRecognizer)
    }

    init(maxCount: Int, handler: @escaping () -> Void) {
        self.maxCount = maxCount
        self.handler = handler
    }

    // MARK: Private

    private let maxCount: Int
    private let handler: () -> Void
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))

    @objc
    private func tap() {
        guard let c = count else {
            count = 0
            return
        }

        if c >= (maxCount - 1) {
            count = nil
        } else {
            count = c + 1
        }
    }
}
