import UIKit


class MenuPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else {
            return .zero
        }
        
        let containerSize = container.bounds.size
        let menuHeight = self.menuHeight
        
        return CGRect(x: 0,
                      y: max(containerSize.height - menuHeight, 0),
                      width: containerSize.width,
                      height: min(menuHeight, containerSize.height))
    }
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        guard let menuController = presentedViewController as? MenuController else {
            fatalError("MenuController must be presented")
        }
        
        self.menuController = menuController
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        self.menuController.onHeightUpdate = { [weak self] in
            self?.updateMenuHeight()
        }
    }
    
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard let container = containerView else { return }
        
        dimmingView?.frame = container.bounds
        updateMenuHeight()
    }
    
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let container = containerView, let presentedView = presentedView else { return }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDimmingViewTap))
        let dimmingView = UIView()
        dimmingView.backgroundColor = .black.withAlphaComponent(0.32)
        dimmingView.alpha = 0.0
        dimmingView.addGestureRecognizer(tapRecognizer)
        container.insertSubview(dimmingView, belowSubview: presentedView)
        self.dimmingView = dimmingView
        
        let showDimmingView = {
            dimmingView.alpha = 1.0
        }
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate { _ in
                showDimmingView()
            }
        } else {
            showDimmingView()
        }
    }
    
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        let removeDimmingView = { [weak self] in
            self?.dimmingView?.removeFromSuperview()
            self?.dimmingView = nil
        }
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate { [weak self] _ in
                self?.dimmingView?.alpha = 0.0
            } completion: { _ in
                removeDimmingView()
            }
        } else {
            removeDimmingView()
        }
    }
    
    
    // MARK: - Private
    
    private let menuController: MenuController
    
    
    private var dimmingView: UIView?
    
    
    private var menuHeight: CGFloat {
        let height = menuController.contentHeight
        
        if height > 0 {
            return height
        }
        
        return 48
    }
    
    
    private func updateMenuHeight() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    
    @objc private func handleDimmingViewTap() {
        presentedViewController.dismiss(animated: true)
    }
}
