import UIKit


protocol Counter {
    var count: Int? { get }
}


class TapsCounter: Counter {

    public var count: Int? {
        didSet {
            handler()
        }
    }


    public func beginCountTaps(on view: UIView) {
        view.addGestureRecognizer(tapGestureRecognizer)
    }


    public func endCountTaps(on view: UIView) {
        view.removeGestureRecognizer(tapGestureRecognizer)
    }


    init(maxCount: Int, handler: @escaping () -> Void) {
        self.maxCount = maxCount
        self.handler = handler
    }

    // MARK: Private

    private let maxCount: Int
    private let handler: (() -> ())
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(tap))
    }()


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
