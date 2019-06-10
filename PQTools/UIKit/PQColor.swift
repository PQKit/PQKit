//
//  PQColor.swift
//  PQ
//
//  Created by 盘国权 on 2018/12/14.
//  Copyright © 2018 pgq. All rights reserved.
//

import UIKit

public struct PQColor<T>: PQType{
    //internal 默认的访问级别，可以不写
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}


public extension UIColor {
    var pq: PQColor<UIColor> {
        return PQColor(pq: self)
    }
}

public extension PQColor where WrapperType == UIColor {
    func red() -> Float {
        var red: CGFloat = 0
        pq.getRed(&red, green: nil, blue: nil, alpha: nil)
        return Float(red)
    }
    func green() -> Float {
        var green: CGFloat = 0
        pq.getRed(nil, green: &green, blue: nil, alpha: nil)
        return Float(green)
    }
    func blue() -> Float {
        var blue: CGFloat = 0
        pq.getRed(nil, green: nil, blue: &blue, alpha: nil)
        return Float(blue)
    }
    func alpha() -> Float {
        var alpha: CGFloat = 0
        pq.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return Float(alpha)
    }
    func hue() -> Float {
        var hue: CGFloat = 0
        pq.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return Float(hue)
    }
    func saturation() -> Float {
        var saturation: CGFloat = 0
        pq.getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
        return Float(saturation)
    }
    func brightness() -> Float {
        var brightness: CGFloat = 0
        pq.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return Float(brightness)
    }
    
    func redUInt8() -> UInt8 {
        return UInt8(red() * 255)
    }
    func greenUInt8() -> UInt8 {
        return UInt8(green() * 255)
    }
    func blueUInt8() -> UInt8 {
        return UInt8(blue() * 255)
    }
    func alphaUInt8() -> UInt8 {
        return UInt8(alpha() * 255)
    }
    func hueUInt8() -> UInt8 {
        return UInt8(hue() * 255)
    }
    func saturationUInt8() -> UInt8 {
        return UInt8(saturation() * 255)
    }
    func brightnessUInt8() -> UInt8 {
        return UInt8(brightness() * 255)
    }
    
    func rgbUInt8() -> [UInt8] {
        return [redUInt8(),greenUInt8(),blueUInt8()]
    }
    
    func hsbUInt8() -> [UInt8] {
        return [hueUInt8(),saturationUInt8(),brightnessUInt8()]
    }
    
    
    /// 获取颜色的HSB值
    ///
    /// - Returns: 元祖
    func hsb() -> (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat){
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if pq.responds(to: #selector(pq.getHue(_:saturation:brightness:alpha:))) {
            pq.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        }
        return (h,s,b,a)
        
    }
    
    /// r g b [0 - 255] a [0 - 100]
    func rgba(r: UInt8, g: UInt8, b: UInt8, a: UInt8) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 100.0)
    }
    
    /// get color info
    func rgba() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        pq.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red: red, green: green, blue: blue, alpha: alpha)
    }
    
    var hex: String {
        return String(format: "%02x%02x%2x", redUInt8(), greenUInt8(), blueUInt8())
    }
}

public extension UIColor {
    /// 随机颜色HSB
    ///
    /// - Returns: 颜色
    class func pq_randomHSBColor() -> UIColor {
        return UIColor(hue: CGFloat(arc4random() % 100) / 100.0, saturation: 1, brightness: CGFloat(arc4random() % 100) / 100.0, alpha: 1)
    }
    
    /// 随机颜色RGB
    ///
    /// - Returns: 颜色
    class func pq_RandomRGBColor() -> UIColor{
        return UIColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: CGFloat(arc4random() % 255) / 255.0)
    }
    
    /// h s b a [0.0 - 1.0]
    class func pq_hsba(h: Double, s: Double, b: Double, a: Double) -> UIColor {
        return UIColor(hue: CGFloat(h), saturation: CGFloat(s), brightness: CGFloat(b), alpha: CGFloat(a))
    }
    
    
    /// 16进制转化颜色
    ///
    /// - Parameters:
    ///   - value: 数据
    ///   - alpha: 透明度
    /// - Returns: color
    class func pq_hexColor(_ value : Int64, alpha : CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat((((value & 0xFF0000) >> 16))) / 255.0, green: CGFloat((((value & 0xFF00) >> 8))) / 255.0, blue: CGFloat(((value & 0xFF))) / 255.0, alpha: alpha)
    }
    
    
    /// 创建RGB
    ///
    /// - Parameters:
    ///   - red: red
    ///   - green: green
    ///   - blue: blue
    ///   - alpha: alpah
    /// - Returns: color
    class func pq_color(red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    
}


