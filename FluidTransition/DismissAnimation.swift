//
//  DismissAnimation.swift
//  FluidTransition
//
//  Created by 노영재(Youngjae No)_인턴 on 4/29/24.
//

import UIKit

class DismissAnimation: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            fromView.alpha = 0
        }) { (completion) in
            transitionContext.completeTransition(completion)
        }
    }
}
