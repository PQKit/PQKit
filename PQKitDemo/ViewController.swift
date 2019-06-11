//
//  ViewController.swift
//  PQKitDemo
//
//  Created by 盘国权 on 2019/6/10.
//  Copyright © 2019 pgq. All rights reserved.
//

import UIKit
import PQTransition
import PQTools
import PQKit
import RxSwift


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorSlider = PQColorSlider(frame: CGRect(x: 0, y: 50, width: 200, height: 44), colors: [UIColor.yellow, UIColor.white], locations: [0, 1.0], colorHeight: 20, borderColor: .black, borderWidth: 1, dueTime: 0.2)
        colorSlider.currentValue {
            print(Date.timeIntervalSinceReferenceDate, " value - ",$0)
        }
        view.addSubview(colorSlider)
        
        
        
        
    }
    
    var animationTypes: [PQTransitionAnimationType] = [
        .popverSpring,
        .topPush,
        .bottomPush,
        .leftPush,
        .rightPush,
        .fromFrame(beginFrame: CGRect(x: 0, y: 0, width: 20, height: 20)),
        .fromFrame2(beginFrame: CGRect(x: 200, y: 0, width: 20, height: 20)),
        .circleOverlay(beginFrame: CGRect(x: 200, y: 200, width: 100, height: 100)),
        .cutVeritical,
        .cutHorizontal,
        .transFromH
    ]
    
    var index: Int = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if index >= animationTypes.count {
            index = 0
        }
        let sec = SecondViewController()
        sec.transition.type = animationTypes[index]
        index += 1
        present(sec, animated: true, completion: nil)
    }


}

