import UIKit
import OVKit

public protocol FocusOfInterestView: UIView {
    var isFocusOfInterest: Bool { get set }
    
    func touch()
}


public protocol FocusOfInterestTrackerDelegate: AnyObject {
    func focusDidChange(to view: FocusOfInterestView?)
}


public enum FocusOfInterestTrackerVisibility {
    
    case didDisappear
    case willDisappear
    case willAppear
    case didAppear
}


open class FocusOfInterestTracker: NSObject {
    
    weak var delegate: FocusOfInterestTrackerDelegate?
    
    private var trackedViews = WeakList<UIView>()
    
    private weak var focusedView: FocusOfInterestView? {
        didSet {
            if focusedView !== oldValue {
                delegate?.focusDidChange(to: focusedView)
            }
        }
    }
    
    private let origin: UIView
    
    // MARK: - Initializers
    
    public init(with origin: UIView) {
        self.origin = origin
    }
    
    // MARK: - Public
    
    var visibility: FocusOfInterestTrackerVisibility = .didDisappear {
        didSet {
            guard visibility != oldValue else { return }
            updateFocus()
        }
    }
    
    public func trackView(_ view: UIView) {
        trackedViews.addObject(view)
        updateFocus()
    }
    
    
    public func untrackView(_ view: UIView) {
        trackedViews.removeObject(view)
    }
    
    
    public func touch() {
        focusedView?.touch()
    }
    
    
    public func updateFocus() {
        guard visibility == .didAppear else {
            return
        }
        
        let originBounds = origin.bounds
        let centerLine = originBounds.midY
        
        var focusFound = false
        
        // TODO: Нестабильный порядок по горизонтали
        for view in trackedViews.allObjects {
            guard let trackableView = view as? FocusOfInterestView else { continue }
            
            if focusFound {
                trackableView.isFocusOfInterest = false
            } else {
                let frame = view.convert(view.bounds, to: origin)
                
                if frame.minY < centerLine && frame.maxY > centerLine {
                    trackableView.isFocusOfInterest = true
                    focusedView = trackableView
                    focusFound = true
                } else {
                    trackableView.isFocusOfInterest = false
                }
            }
        }
    }
}
