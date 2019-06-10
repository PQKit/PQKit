//
//  PQTransparentNavigationController.swift
//  Lumary
//
//  Created by 盘国权 on 2018/12/28.
//  Copyright © 2018 pgq. All rights reserved.
//

import UIKit

class PQTransparentNavigationController: PQController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = PQSkip.shared.navigationBar.barTintColor?.spColor
        navigationController?.navigationBar.isTranslucent = false
    }
    
}

