//
//  SecondViewController.swift
//  FluidTransition
//
//  Created by 노영재(Youngjae No)_인턴 on 4/26/24.
//

import UIKit
import Then

class SecondViewController: UIViewController {
    let imageUrlString = "https://raw.githubusercontent.com/onevcat/Kingfisher-TestImages/master/DemoAppImage/Loading/kingfisher-5.jpg"
    
    private let imageView = UIImageView().then{
        $0.contentMode = .scaleAspectFill
//        $0.isUserInteractionEnabled = true
        $0.transitionId = "image_1"
    }
    private let dimmedView = UIView().then{
        $0.backgroundColor = .black
        $0.alpha = 0.5
    }
    
    private func addSubviews() {
        self.view.addSubview(dimmedView)
        self.view.addSubview(imageView)
    }
    
    private func setLayouts() {
        dimmedView.snp.makeConstraints{
            $0.edges
                .equalToSuperview()
        }
        imageView.snp.makeConstraints{
            $0.centerY
                .leading
                .trailing
                .equalTo(self.view.safeAreaLayoutGuide)
            $0.height
                .equalTo(400)
        }
    }
    //MARK: - Method
    private func loadImage(_ urlString: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setLayouts()
        
        loadImage(imageUrlString)
    }


}

extension SecondViewController: UIViewControllerTransitioningDelegate {
    
}
