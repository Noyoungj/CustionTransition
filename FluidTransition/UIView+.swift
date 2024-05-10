//
//  UIView+.swift
//  FluidTransition
//
//  Created by 노영재(Youngjae No)_인턴 on 5/9/24.
//

import UIKit

private var transitionContext: UInt8 = 0

extension UIView {
    
    func synchronized<T>(_ action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
    
    public var transitionId: String? {
        get {
            return synchronized {
                if let transitionId = objc_getAssociatedObject(self, &transitionContext) as? String {
                    return transitionId
                }
                return nil
            }
        }
        
        set {
            synchronized {
                objc_setAssociatedObject(self, &transitionContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func view(withId id: String?) -> UIView? {
        if id?.isEmpty == true { return nil }
        return self.subviews.first { $0.transitionId == id }
    }
}

