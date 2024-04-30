//
//  MyCustomTransition.swift
//  FluidTransition
//
//  Created by 노영재(Youngjae No)_인턴 on 4/26/24.
//

import UIKit

final class MyCustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let originFrame: CGRect
    private let originPoint: CGPoint
    
    init(originFrame: CGRect, originPoint: CGPoint) {
        self.originFrame = originFrame
        self.originPoint = originPoint
    }
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.1
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        transitionAnimation(transitionContext)

    }
    
    
    func transitionAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        toView.frame = originFrame
        toView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)
        
        toView.layer.masksToBounds = true
        toView.layer.cornerRadius = 20
        toView.alpha = 0
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: {
            toView.transform = .identity
            toView.alpha = 1
        }) { _ in
            toView.snp.makeConstraints { make in
                make.edges.equalTo(containerView)
            }
            UIView.animate(withDuration: 1) {
                containerView.layoutIfNeeded()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("animationEnded \(transitionCompleted)")
    }
}


