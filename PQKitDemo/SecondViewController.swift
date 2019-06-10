//
//  SecondViewController.swift
//  PQKitDemo
//
//  Created by 盘国权 on 2019/6/10.
//  Copyright © 2019 pgq. All rights reserved.
//

import UIKit
import PQTransition

class SecondViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function, self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        
        
        
    }
    
    lazy var transition: PQTransition = {
        let transition = PQTransition(type: .bottomPush, presentFrame: CGRect(x: 20, y: 100, width: 300, height: 300))
        transition.willShow {[unowned self] in
            print(self.transition.type, "will show")
        }
        transition.didShow {[unowned self] in
            print(self.transition.type, "did show")
        }
        transition.willDismiss {[unowned self] in
            print(self.transition.type, "will dismiss")
        }
        transition.didDismiss {[unowned self] in
            print(self.transition.type, "did dismiss")
        }
        return transition
    }()
}
