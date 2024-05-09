//
//  DismissAnimation.swift
//  FluidTransition
//
//  Created by 노영재(Youngjae No)_인턴 on 4/29/24.
//

import UIKit

class DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    private var animator: UIViewImplicitlyAnimating?
        
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
              let toVC = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return UIViewPropertyAnimator()
        }
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.white
        containerView.insertSubview(toVC.view, belowSubview: toVC.view)
        
        toVC.view.alpha = 0
        fromVC.view.alpha = 1
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            curve: .easeOut) {
                toVC.view.alpha = 1
                fromVC.view.alpha = 0
            }
        
        animator.addCompletion { position in
            switch position {
            case .start:
                fromVC.view.alpha = 1
                toVC.view.alpha = 0
                self.animator = nil
            case .end:
                toVC.view.alpha = 1
                fromVC.view.alpha = 0
            case .current: break
            @unknown default: break
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            // black screen after transition
            UIApplication.shared.keyWindow?.addSubview(toVC.view)
            
        }
        self.animator = animator
        return animator
    }
}
