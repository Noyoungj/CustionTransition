//
//  DismissAnimation.swift
//  FluidTransition
//
//  Created by 노영재(Youngjae No)_인턴 on 4/29/24.
//

import UIKit

class DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    private var animator: UIViewImplicitlyAnimating?
    private var frame: CGRect
    private let transitionId: String
    
    init(frame: CGRect, transitionId: String) {
        self.frame = frame
        self.transitionId = transitionId
    }
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        if animator.state == .inactive {
            animator.startAnimation()
        }
    }
    
    func interruptibleAnimator(using transitionContext: any UIViewControllerContextTransitioning) -> any UIViewImplicitlyAnimating {
        if self.animator != nil {
            return self.animator!
        }
        
        let rootVC = transitionContext.viewController(forKey: .from)
        let _fromVC = rootVC?.navigationController?.topViewController ?? rootVC
        guard let fromVC = _fromVC,
            let targetView = fromVC.view.view(withId: transitionId),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = targetView.snapshotView(afterScreenUpdates: true)
            else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return UIViewPropertyAnimator()
        }
        
        let initialFrame = targetView.frame
        let finalFrame = self.frame

        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.clear
        containerView.insertSubview(toVC.view, belowSubview: toVC.view)
        containerView.addSubview(snapshot)
        snapshot.frame = initialFrame
        
        toVC.view.alpha = 1
        fromVC.view.alpha = 0
        targetView.alpha = 0

        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            curve: .easeOut) {
                toVC.view.alpha = 1
                fromVC.view.alpha = 0
                snapshot.frame = finalFrame
            }
        
        animator.addCompletion { position in
            switch position {
            case .start:
                fromVC.view.alpha = 1
                toVC.view.alpha = 1
                targetView.alpha = 1
                self.animator = nil
                snapshot.removeFromSuperview()
                UIApplication.shared.keyWindow?.addSubview(fromVC.view)
            case .end:
                toVC.view.alpha = 1
                fromVC.view.alpha = 0
                targetView.alpha = 0
                UIApplication.shared.keyWindow?.addSubview(toVC.view)
            case .current: break
            @unknown default: break
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            // black screen after transition
        }
        self.animator = animator
        return animator
    }
}
