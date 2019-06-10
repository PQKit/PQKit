//
//  PQProgressWaveLayer.swift
//  PQProgressView
//
//  Created by 盘国权 on 2018/8/4.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit


open class PQProgressWaveLayer: PQProgressBaseLayer {
    
    var color: UIColor = .white
    convenience init(color: UIColor) {
        self.init()
        self.color = color
    }
    
    override open func update(progress: Float) {
        
    }
    
    override open func drawUI() {
        
    }
    
}

