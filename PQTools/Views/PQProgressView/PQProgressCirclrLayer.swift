//
//  PQProgressCirclrLayer.swift
//  PQProgressView
//
//  Created by 盘国权 on 2018/8/4.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

open class PQProgressCirclrLayer: PQProgressBaseLayer {
    var circleBackgrouncColor: UIColor = .gray
    var foregroundColor: UIColor = .white
    convenience init(backgroundColor: UIColor, foregroundColor: UIColor) {
        self.init()
        
        self.circleBackgrouncColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    override open func update(progress: Float) {
        foregroundCircleLayer.strokeEnd = CGFloat(progress)
    }
    
    override open func drawUI() {
        setLayer(storkColor: circleBackgrouncColor.cgColor, layer: self)
        setLayer(storkColor: foregroundColor.cgColor, layer: foregroundCircleLayer)
    }
    
    private func setLayer(storkColor: CGColor, layer: CAShapeLayer) {
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.width * 0.5, y: frame.height * 0.5), radius: frame.width * 0.49, startAngle: CGFloat(-Double.pi * 0.5), endAngle: CGFloat(Double.pi * 2) + CGFloat(-Double.pi * 0.5), clockwise: true)
        
        layer.fillColor = nil
        layer.lineWidth = 10
        layer.lineCap = CAShapeLayerLineCap(rawValue: "round")
        layer.fillColor = nil
        layer.strokeColor = storkColor
        layer.path = path.cgPath
        
    }
    
    private lazy var foregroundCircleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.addSublayer(layer)
        return layer
    }()
}


