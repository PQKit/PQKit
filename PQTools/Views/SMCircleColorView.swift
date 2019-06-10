//
//  SMCircleColorView.swift
//  SmartMore
//
//  Created by 盘国权 on 2019/5/3.
//  Copyright © 2019 pgq. All rights reserved.
//

import UIKit

class SMCircleColorView: PQCircleColorView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        self.isCanRoration = false
        self.isShowTriangle = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 1、给白色圆圈设置默认的位置 2、保存一张图片用于取色
    override func layoutSubviews() {
        if pointImageView.frame.origin == .zero {
            pointImageView.frame = CGRect(x: (frame.width - imageSize.width) * 0.5, y: 5, width: imageSize.width, height: imageSize.height)
            let radius = frame.width
            let center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
            
            // 用来计算当前的图标位置
            for i in 0...360 {
                let secA = CGFloat(i) / 180.0 * CGFloat.pi + CGFloat.pi
                let a = radius * sin(secA)
                let b = radius * cos(secA)
                
                /// 最外面的点
                let point = CGPoint(x: b * (begin + end) * 0.5 + center.x, y: a * (begin + end) * 0.5 + center.y)
                if (hue - (Float(i) / 360.0)) < 0.01 {
                    pointImageView.center = point
                    break
                }
            }
        }
        if bgImage == nil {
            renderImage()
        }
    }
    
    // MARK: - private property
    let imageSize = CGSize(width: 60, height: 60)
    lazy var shadowImage = UIImage.pq_drawShadowImage(imageSize.width * 0.5, size: imageSize, color: .white, shadowColor: UIColor.gray)
    private lazy var pointImageView = UIImageView(image: shadowImage)
    private var bgImage: UIImage?
    
    private var hue: Float = 0.0
}

extension SMCircleColorView {
    func setPointFrame(color: UIColor) {
        hue = color.pq.hue()
        
        print("color hue", hue)
        
    }
}

private extension SMCircleColorView {
    func setup() {
        addSubview(pointImageView)
        
        pointImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        pointImageView.isUserInteractionEnabled = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pointImageViewMove))
        pointImageView.addGestureRecognizer(pan)
    }
    
    @objc private func pointImageViewMove(_ pan: UIPanGestureRecognizer) {
        let point = pan.location(in: self)
        
        let min = self.begin * frame.width
        let max = self.end * frame.width
        let current = CGFloat(distanceWithFrom(from: point, to: pq.center))
        
        if current > min && current < max {
            self.pointImageView.frame.origin = CGPoint(x: point.x - 25, y: point.y - 25)
            if let color = bgImage?.pq.color(point: point, viewSize: bounds.size)
            {
                colorClosure?(color)
            }
        }
    }
    
    private func distanceWithFrom(from: CGPoint, to: CGPoint) -> Float {
        let x = from.x - to.x
        let y = from.y - to.y
        let distance = sqrtf(Float(pow(x, 2) + pow(y, 2)))
        return distance
    }
    
    private func renderImage() {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if let context = context {
            self.layer.render(in: context)
        }
        bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
}
