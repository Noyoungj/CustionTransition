//
//  DismissAnimation.swift
//  FluidTransition
//
//  Created by 노영재(Youngjae No)_인턴 on 4/29/24.
//

import UIKit

class DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        if animator.state == .inactive {
            animator.startAnimation()
        }
    }
    
    func interruptibleAnimator(using transitionContext: any UIViewControllerContextTransitioning) -> any UIViewImplicitlyAnimating {
        guard let fromView = transitionContext.view(forKey: .from) else { return UIViewPropertyAnimator() }
        
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            fromView.alpha = 0
        }
        animator.addCompletion { position in
            switch position {
            case .start:
                fromView.alpha = 1
            case .end:
                fromView.alpha = 0
            case .current: break
            @unknown default: break
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return animator
    }
}
