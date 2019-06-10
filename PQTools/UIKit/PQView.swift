//
//  UIView.swift
//  LocalLight
//
//  Created by 盘国权 on 2018/11/26.
//  Copyright © 2018 pgq. All rights reserved.
//

import UIKit

public struct PQView<T>: PQType {
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}

extension UIView {
    public var pq: PQView<UIView> {
        return PQView(pq: self)
    }
}

public extension PQView where WrapperType == UIView {
    var width: CGFloat {
        get{ return pq.frame.width }
        set{ pq.frame.size.width = width }
    }
    
    var height: CGFloat{
        get{ return pq.frame.height }
        set{ pq.frame.size.height = height }
    }
    
    var x: CGFloat {
        get{ return pq.frame.origin.x }
        set{ pq.frame.origin.x = x }
    }
    
    var y: CGFloat {
        get{ return pq.frame.origin.y }
        set{ pq.frame.origin.x = y }
    }
    
    var origin: CGPoint {
        get{ return pq.frame.origin }
        set{ pq.frame.origin = origin }
    }
    
    var size: CGSize {
        get{ return pq.frame.size }
        set{ pq.frame.size = size }
    }
    
    var center: CGPoint {
        get{ return CGPoint(x: width * 0.5, y: height * 0.5) }
        set{ pq.center = center }
    }
    
    
    var top: CGFloat {
        return pq.frame.minY
    }
    
    var bottom: CGFloat {
        return pq.frame.maxY
    }
    
    var left: CGFloat {
        return pq.frame.minX
    }
    
    var right: CGFloat {
        return pq.frame.maxX
    }
    
    /// 获取特定位置的颜色
    /// get view color with position 
    ///
    /// - parameter at: 位置
    ///
    /// - returns: 颜色
    func pickColor(at position: CGPoint) -> UIColor? {
        
        // 用来存放目标像素值
        var pixel = [UInt8](repeatElement(0, count: 4))
        // 颜色空间为 RGB，这决定了输出颜色的编码是 RGB 还是其他（比如 YUV）
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // 设置位图颜色分布为 RGBA
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        // 设置 context 原点偏移为目标位置所有坐标
        context.translateBy(x: -position.x, y: -position.y)
        // 将图像渲染到 context 中
        pq.layer.render(in: context)
        
        return UIColor(red: CGFloat(pixel[0]) / 255.0,
                       green: CGFloat(pixel[1]) / 255.0,
                       blue: CGFloat(pixel[2]) / 255.0,
                       alpha: CGFloat(pixel[3]) / 255.0)
    }

}

public extension UIView {
    static var identifier: String {
        return NSStringFromClass(self)
    }
    
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
