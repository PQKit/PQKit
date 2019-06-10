//
//  UIViewController.swift
//  Light
//
//  Created by 盘国权 on 2018/10/13.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

public extension UIViewController {
   
    func pq_convertController<T>(_ segue: UIStoryboardSegue, type: T.Type) -> T {
        guard let controller = segue.destination as? T else {
            fatalError("can't not convert to \(String(describing: segue.identifier))")
        }
        return controller
    }
}
