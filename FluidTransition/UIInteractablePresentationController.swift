//
//  UIInteractablePresentationController.swift
//  ViewTransition
//
//  Created by tskim on 24/08/2019.
//  Copyright © 2019 hucet. All rights reserved.
//
import UIKit

class UIInteractablePresentationController: UIPresentationController {
    
    let panGestureRecognizer = UIPanGestureRecognizer()
    let transactionId: String
    
    override func presentationTransitionWillBegin() {
        print("call presentationTransitionWillBegin")
        super.presentationTransitionWillBegin()
        guard let presentedView = presentedView else { return }
        presentedView.addGestureRecognizer(panGestureRecognizer)
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, transactionId: String) {
            self.transactionId = transactionId
            super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        print("call presentationTransitionDidEnd: \(completed)")
        super.presentationTransitionDidEnd(completed)
    }
    
    @objc
    func dismissalGesture(gesture: UIPanGestureRecognizer) {
        
    }
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        print("call dismissalTransitionDidEnd: \(completed)")
    }
    override func dismissalTransitionWillBegin() {
        print("call dismissalTransitionWillBegin")
    }
}
