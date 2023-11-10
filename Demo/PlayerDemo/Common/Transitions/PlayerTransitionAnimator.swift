import UIKit
import OVKit


/**
 Аниматор переходов между ViewController-ами, который можно использовать для presentation и dismiss.
 
 Умеет переносить указанный плеер с одного экрана на другой с анимацией.
 */
class PlayerTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private(set) weak var sourcePlayerProvider: PlayerViewProvider?
    private(set) weak var destinationPlayerProvider: PlayerViewProvider?
    
    init(sourcePlayerProvider: PlayerViewProvider?, destinationPlayerProvider: PlayerViewProvider?) {
        self.sourcePlayerProvider = sourcePlayerProvider
        self.destinationPlayerProvider = destinationPlayerProvider
        
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.32
    }

    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
                  assertionFailure()
                  return
        }

        let fromView = fromVC.view!
        let toView = toVC.view!
        
        let isPresentation = toVC.presentedViewController != fromVC
        let isDismiss = !isPresentation
        
        if isPresentation {
            transitionContext.containerView.addSubview(toView)
        }
        
        var playerTransition: PlayerViewAnimatedTransition?
        
        // Если есть откуда и куда переносить плеер
        if let fromPlayerView = sourcePlayerProvider?.currentPlayerView,
           let toPlayerView = destinationPlayerProvider?.currentPlayerView {

            playerTransition = fromPlayerView.createAnimatedTransition(to: toPlayerView, in: transitionContext.containerView)
            
            if isPresentation {
                // Чтобы выставился корректный фрейм для PlayerView
                toView.layoutIfNeeded()
            }
        }

        playerTransition?.prepare()
        
        if isPresentation {
            toView.alpha = 0.0
        }
        
        if isDismiss {
            toVC.viewWillAppear(true)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       options: [.curveEaseInOut]) {
            playerTransition?.animateToDestination()
            
            if isPresentation {
                toView.alpha = 1.0
            } else {
                fromView.alpha = 0.0
            }
        } completion: { completed in
            playerTransition?.finish(completed: completed)
            self.destinationPlayerProvider?.didReceivePlayer()
            
            if isPresentation, transitionContext.transitionWasCancelled {
                toVC.view.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            if isDismiss {
                toVC.viewDidAppear(true)
            }
        }
    }
}
