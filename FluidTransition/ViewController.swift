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
    let imageUrlString = "https://raw.githubusercontent.com/onevcat/Kingfisher-TestImages/master/DemoAppImage/Loading/kingfisher-5.jpg"

    var transition : MyCustomTransition?
    var dismissal: InteractiveTransition?
    var uiPresentation: UIInteractablePresentationController?
    
    private let button = UIButton().then{
        $0.transitionId = "image_1"
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
    
    //MARK: - Action Method
    @objc
    private func nextViewAction(_ sender: UIButton) {
        let nextVC = SecondViewController()
        nextVC.transitioningDelegate = self
        transition = MyCustomTransition(originFrame: self.button.frame, transitionId: "image_1")
        nextVC.modalPresentationStyle = .custom
        self.uiPresentation = UIInteractablePresentationController(presentedViewController: nextVC, presenting: self, transactionId: "image_1")
        dismissal = InteractiveTransition(gesture: self.uiPresentation!.panGestureRecognizer, animator: DismissAnimation(frame: button.frame,transitionId: "image_1"), presented: nextVC)
        self.present(nextVC, animated: true)
    }
    
    //MARK: - Method
    private func loadImage(_ urlString: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.button.setImage(UIImage(data: data), for: .normal)
                self.button.layoutIfNeeded()
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
        addSubviews()
        setLayouts()
        
        loadImage(self.imageUrlString)
    }


}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return DismissAnimation(frame: self.button.frame,transitionId: "image_1")
    }
    
    func interactionControllerForDismissal(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        
        return dismissal
    }
    
    open func presentationController(forPresented presented: UIViewController,
                                     presenting: UIViewController?,
                                     source: UIViewController) -> UIPresentationController? {
        return uiPresentation
    }
}
