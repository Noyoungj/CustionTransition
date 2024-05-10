//
//  MyCustomTransition.swift
//  FluidTransition
//
//  Created by 노영재(Youngjae No)_인턴 on 4/26/24.
//

import UIKit

final class MyCustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let originFrame: CGRect
    private let transitionId: String

    init(originFrame: CGRect, transitionId: String) {
        self.originFrame = originFrame
        self.transitionId = transitionId
    }
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let targetView = fromVC.view.view(withId: transitionId),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = targetView.snapshotView(afterScreenUpdates: true),
            let toView = toVC.view.view(withId: transitionId)
        else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        
        targetView.transitionId = transitionId
        
        let initialFrame = originFrame
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.clear
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        containerView.addSubview(snapshot)
        snapshot.frame = initialFrame
        
        
        // layoutIfNeeded 를 호출하지 않으면 y 값이 어긋남
        toVC.view.layoutIfNeeded()
        
        toVC.view.alpha = 0
        toView.alpha = 0
        let finalFrame = toView.frame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: [UIView.AnimationOptions.transitionCrossDissolve],
                       animations: {
            fromVC.view.alpha = 1
            toVC.view.alpha = 1
            snapshot.frame = finalFrame
        },
                       completion: { completed in
            toVC.view.alpha = 1
            toView.alpha = 1
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    
    func transitionAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("animationEnded \(transitionCompleted)")
    }
}


