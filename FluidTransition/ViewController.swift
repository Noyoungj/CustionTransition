//
//  ViewController.swift
//  FluidTransition
//
//  Created by 노영재(Youngjae No)_인턴 on 4/26/24.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    var transition : MyCustomTransition?
    var dismissal: InteractiveTransition?
    var uiPresentation: UIInteractablePresentationController?
    
    private let button = UIButton().then{
        $0.setTitle("다음 페이지", for: .normal)
        $0.backgroundColor = .red
        $0.addTarget(self, action: #selector(nextViewAction(_:)), for: .touchUpInside)
    }
    
    private func addSubviews() {
        self.view.addSubview(button)
    }
    
    private func setLayouts() {
        self.button.snp.makeConstraints{
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.height
                .width
                .equalTo(100)
        }
    }
    @objc
    private func nextViewAction(_ sender: UIButton) {
        let nextVC = SecondViewController()
        nextVC.transitioningDelegate = self
        transition = MyCustomTransition(originFrame: self.button.frame, originPoint: self.button.center)
        nextVC.modalPresentationStyle = .custom
        self.uiPresentation = UIInteractablePresentationController(presentedViewController: nextVC, presenting: self)
        dismissal = InteractiveTransition(gesture: self.uiPresentation!.panGestureRecognizer, animator: DismissAnimation(), presented: nextVC)

        self.present(nextVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        addSubviews()
        setLayouts()

    }


}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return DismissAnimation()
    }
    
    func interactionControllerForDismissal(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        print("사라진다아")
        return dismissal
    }
    
    open func presentationController(forPresented presented: UIViewController,
                                     presenting: UIViewController?,
                                     source: UIViewController) -> UIPresentationController? {
        return uiPresentation
    }
}
