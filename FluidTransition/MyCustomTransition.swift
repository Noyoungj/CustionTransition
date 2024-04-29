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
        return 5
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        toView.frame = originFrame
        toView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)
        
        toView.layer.masksToBounds = true
        toView.layer.cornerRadius = 20
        toView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5,options: .curveEaseOut, animations: {
            toView.transform = .identity
            toView.alpha = 1
        }) { _ in
            toView.translatesAutoresizingMaskIntoConstraints = false
            toView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            toView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            toView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            toView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            
            UIView.animate(withDuration: 1) {
                containerView.layoutIfNeeded()
            }
        }
        
        transitionContext.completeTransition(true)
    }
}
