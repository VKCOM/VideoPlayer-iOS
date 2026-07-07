import UIKit

public enum SurfaceAnimate {

    public typealias Completion = (Bool) -> Void

    public static func snappy(
        duration: TimeInterval,
        options: UIView.AnimationOptions = [],
        animations: @escaping () -> Void,
        completion: Completion? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options.union(.allowUserInteraction),
            animations: animations,
            completion: completion
        )
    }

    public static func snappyKeyframes(
        duration: TimeInterval,
        options: UIView.KeyframeAnimationOptions = [],
        animations: @escaping () -> Void,
        completion: Completion? = nil
    ) {
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: options.union(.allowUserInteraction),
            animations: animations,
            completion: completion
        )
    }

    public static func spring(
        duration: TimeInterval,
        delay: CGFloat = 0,
        damping: CGFloat = 1,
        initialVelocity: CGFloat = 0,
        options: UIView.AnimationOptions = [],
        animations: @escaping () -> Void,
        completion: Completion? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: damping,
            initialSpringVelocity: initialVelocity,
            options: options.union(.allowUserInteraction).union(.beginFromCurrentState),
            animations: animations,
            completion: completion
        )
    }

    public static var infiniteLoading: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = Double.pi * 2
        animation.duration = 1.0
        animation.repeatCount = .infinity
        return animation
    }

    public static func noAnimations(_ actionsWithoutAnimation: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
}
