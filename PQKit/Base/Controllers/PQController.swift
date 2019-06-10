//
//  PQController.swift
//  Lumary
//
//  Created by 盘国权 on 2018/12/17.
//  Copyright © 2018 pgq. All rights reserved.
//

import UIKit
import PQTools

public protocol PQInitControllerType {
    /// 导航栏的设置
    func nav()
    /// 包括视图的添加和约束
    func setup()
    /// 视图的数据绑定
    func binding()
    /// 数据的加载
    func loadData()
}

open class PQController: UIViewController, PQNavigationItem {

    // MARK: system method
    override open func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = PQSkip.shared.controller.backgroundColor?.spColor
    }
    
    // MARK: - 监听是否释放
    deinit {
        print(self, #function)
    }
    
    // MARK: - 回弹键盘
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - 设置状态栏样式
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override open var prefersStatusBarHidden: Bool {
        return false
    }
    
}
