//
//  PQCircleColorView.swift
//  SmartMore
//
//  Created by 盘国权 on 2019/5/3.
//  Copyright © 2019 pgq. All rights reserved.
//

import Foundation

/*色盘View
 两个步骤
    1、绘制圆环
    2、计算角度得到颜色
 */

open class PQCircleColorView: UIView {
    
    public typealias PQCircleColorClosure = (UIColor) -> ()
    
    /// 绘制的起点相对位置 0~0.5
    open var begin: CGFloat = 0.25
    /// 绘制的终点相对位置 0~0.5 需要注意的是 起点要小于终点，否则可能不显示UI
    open var end: CGFloat = 0.5
    /// 是不是可以旋转
    open var isCanRoration: Bool = true
    /// 是否显示三角指示点
    open var isShowTriangle: Bool = true
    /// time span
    open var timeSpan: Double = 0.1
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
    
    override open func draw(_ rect: CGRect) {
        /// 中心点
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        /// 半径
        let radius = rect.width
        
        /// 画色盘
        drawCircleColor(center: center, radius: radius)
        
        /// 画三角形
        drawTriangle(center: center, radius: radius)
    }
    
    private func drawCircleColor(center: CGPoint, radius: CGFloat) {
        for i in 0...360 {
            let secA = CGFloat(i) / 180.0 * CGFloat.pi + CGFloat.pi
            let a = radius * sin(secA)
            let b = radius * cos(secA)
            
            /// 最外面的点
            let startPoint = CGPoint(x: b * begin + center.x, y: a * begin + center.y)
            let endPoint = CGPoint(x: b * end + center.x, y: a * end + center.y)
            
            /// 新建贝塞尔曲线
            let path = UIBezierPath()
            path.lineWidth = isiPad ? 25 : 5
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            path.stroke()
            
            // 填充颜色
            UIColor(hue: CGFloat(i) / 360.0, saturation: 1, brightness: 1, alpha: 1).set()
        }
    }
    
    private func drawTriangle(center: CGPoint, radius: CGFloat) {
        if !isShowTriangle { return }
        UIColor.white.setStroke()
        var myCenter = center
        myCenter.y += 3
        let path = UIBezierPath(arcCenter: myCenter, radius: radius, startAngle: degreesToRadians(degrees: -110), endAngle: degreesToRadians(degrees: -70), clockwise: true)
        
        path.addLine(to: CGPoint(x: myCenter.x, y: frame.width * 0.1))
        path.close()
        path.lineWidth = 1.5;
        path.stroke();
    }
    
    // MARK: - private property
    private var offsetDegrees: CGFloat = 0
    private var lastDegrees: CGFloat = 0
    private var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    internal var colorClosure: PQCircleColorClosure?
    private var lastTime: Double = CFAbsoluteTimeGetCurrent()
}

public extension PQCircleColorView {
    func nowColor(_ closure: PQCircleColorClosure?) {
        colorClosure = closure
    }
}

// MARK: - touches event
extension PQCircleColorView {
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, isCanRoration else { return }
        let color = updateView(touch)
        let now = CFAbsoluteTimeGetCurrent()
        if now - lastTime > timeSpan {
            lastTime = now
            colorClosure?(color)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, isCanRoration else { return }
        let color = updateView(touch)
        let now = CFAbsoluteTimeGetCurrent()
        if now - lastTime > timeSpan {
            lastTime = now
            colorClosure?(color)
        } else {
            let time = timeSpan - now - lastTime
            lastTime = now + timeSpan
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + time) {
                DispatchQueue.main.async {
                    self.colorClosure?(color)
                }
            }
        }
    }
    
    private func updateView(_ touch: UITouch) -> UIColor {
      
        /// 分别拿到这次和上一次的点
        let currentPoint = touch.location(in: touch.view)
        let previousPoint = touch.previousLocation(in: touch.view)
        
        // result angle
        offsetDegrees += (mDegree(point: currentPoint) - mDegree(point: previousPoint))
        let degrees = (lastDegrees + offsetDegrees).truncatingRemainder(dividingBy: 360)
        let angle = degreesToRadians(degrees: CGFloat(degrees))
        self.transform = CGAffineTransform(rotationAngle: angle)
        
        // result color
        let hue = (360-degrees)/360.0 + 0.25;
        let color = UIColor(hue: hue > 1 ? hue - 1.0 : hue, saturation: 1, brightness: 1, alpha: 1)
        return color
    }
    
    /// 计算角度
    private func mDegree(point: CGPoint) -> CGFloat {
        let x = point.x - self.frame.width * 0.5
        let y = point.y - self.frame.height * 0.5
        
        return radiansToDegrees(radians: (CGFloat(atan2f(Float(y), Float(x)) + 180)))
    }
}

private extension PQCircleColorView {
    func radiansToDegrees(radians: CGFloat) -> CGFloat {
        return radians * 180 / CGFloat.pi
    }
    func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees / 180 * CGFloat.pi
    }
}
