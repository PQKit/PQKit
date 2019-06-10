//
//  PQNavigationController.swift
//  Lumary
//
//  Created by 盘国权 on 2018/12/17.
//  Copyright © 2018 pgq. All rights reserved.
//

import UIKit

class PQNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        navigationBar.barTintColor = PQSkip.shared.navigationBar.barTintColor?.spColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: PQSkip.shared.navigationBar.tintColor?.spColor ?? .black,
                                             NSAttributedString.Key.font: PQSkip.shared.navigationBar.font.font]
        navigationBar.tintColor = PQSkip.shared.navigationBar.tintColor?.spColor
        
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    

    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            
            (viewController as? PQController)?.pq_pop()
//            let item = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(pop))
//
//            item.tintColor = UIColor.titleColor
//            viewController.navigationItem.leftBarButtonItem = item
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func pop() {
        if presentationController != nil || presentingViewController != nil ,
            viewControllers.count == 1{
            self.dismiss(animated: true, completion: nil)
        } else {
            self.popViewController(animated: true)
        }
    }
}

extension PQNavigationController: UIGestureRecognizerDelegate{
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        
        return viewControllers.count == 1 ? false : true
    }
}
