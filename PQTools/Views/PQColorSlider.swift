//
//  PQColorSlider.swift
//  PQTools
//
//  Created by 盘国权 on 2019/6/10.
//  Copyright © 2019 pgq. All rights reserved.
//

import UIKit

open class PQColorSlider: UISlider {
    
    //MARK: - public colosure
    public typealias PQColorSliderClosure = (Float) -> ()

   // MARK: - public property
    open var colors: [UIColor]
    open var locations: [NSNumber]
    open var borderColor: UIColor? = nil
    open var borderWidth: CGFloat = 0
    open var colorHeight: CGFloat = 20
    open var dueTime: TimeInterval = 0.1
    
    public init(frame: CGRect,
         colors: [UIColor],
         locations: [NSNumber],
         colorHeight: CGFloat = 20,
         borderColor: UIColor? = nil,
         borderWidth: CGFloat = 0,
         dueTime: TimeInterval = 0.1) {
        self.colors = colors
        self.locations = locations
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.colorHeight = colorHeight
        self.dueTime = dueTime
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.colors = [.white]
        self.locations = [1]
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func draw(_ rect: CGRect) {
        drawImage()
    }
    
    // MARK: - private property
    
    lazy var colorImageView: UIImageView = {
        let imgView = UIImageView()
        self.insertSubview(imgView, at: 2)
        return imgView
    }()
    var lastTime: TimeInterval = CFAbsoluteTimeGetCurrent()
    var lastValue: Float = 0
    private var closure: PQColorSliderClosure?
}

public extension PQColorSlider {
    func currentValue(closure: PQColorSliderClosure?) {
        self.closure = closure
    }
}

private extension PQColorSlider {
    func setup() {
        tintColor = .clear
        minimumTrackTintColor = .clear
        maximumTrackTintColor = .clear
        
        addTarget(self, action: #selector(valueChange), for: .valueChanged)
        
        addTarget(self, action: #selector(endMove), for: .touchUpInside)
        
        addTarget(self, action: #selector(endMove), for: .touchUpOutside)
    }
    
    func drawImage() {
        // set imageView frame
        colorImageView.frame = CGRect(x: 0, y: (frame.height - colorHeight) * 0.5, width: frame.width, height: colorHeight)
        
        // draw image
        let image = UIImage.colorImage(colors: colors, locations: locations, size: CGSize(width: frame.width, height: colorHeight), borderwidth: borderWidth, borderColor: borderColor)
        colorImageView.image = image
    }
    
    @objc func valueChange() {
        if lastValue == value {
            return
        }
        lastValue = value
        let now = CFAbsoluteTimeGetCurrent()
        if now - lastTime > dueTime {
            lastTime = now
            self.closure?(value)
        }
    }
    
    @objc func endMove() {
        if lastValue == value {
            return
        }
        let now = CFAbsoluteTimeGetCurrent()
        if now - lastTime > dueTime {
            lastTime = now
            self.closure?(value)
        } else {
            let time = dueTime - (now - lastTime)
            PQGCD.after(time) {
                self.closure?(self.value)
            }
            lastTime = now
        }
    }
}

extension UIImage {
    class func colorImage(colors: [UIColor], locations: [NSNumber], size: CGSize, borderwidth: CGFloat, borderColor: UIColor?) -> UIImage{
        assert(colors.count == locations.count, "Please make sure colors and locations count is equal")
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            print("UIGraphicsGetCurrentContext is nil")
            UIGraphicsEndImageContext()
            return UIImage()
        }
        
        if borderwidth > 0 ,
            let borderColor = borderColor {
            
            borderColor.setFill()
            UIBezierPath(roundedRect: CGRect(x: size.width * 0.01, y: 0, width: size.width * 0.98, height: size.height), cornerRadius: size.height * 0.5).fill()
        }
        
        let path = UIBezierPath(roundedRect: CGRect(x: size.width * 0.01 + borderwidth, y: borderwidth, width: size.width * 0.98 - borderwidth * 2, height: size.height - borderwidth * 2), cornerRadius: size.height * 0.5)
        
        drawLinearGradient(context: context, path: path.cgPath, colors: colors, locations: locations)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    private class func drawLinearGradient(context: CGContext, path: CGPath, colors: [UIColor], locations: [NSNumber]) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorRefs = colors.map { $0.cgColor }
        
        let mp = UnsafeMutablePointer<CGFloat>.allocate(capacity: locations.count)
        mp.initialize(repeating: 0, count: locations.count)
        locations.enumerated().forEach { arg in
            let (offset, element) = arg
            mp[offset] = CGFloat(element.floatValue)
        }
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colorRefs as CFArray, locations: mp)
        
        let pathRect = path.boundingBox
        
        let startP = CGPoint(x: pathRect.minX, y: pathRect.midY)
        let endP = CGPoint(x: pathRect.maxX, y: pathRect.midY)
        
        context.saveGState()
        context.addPath(path)
        context.clip()
        context.drawLinearGradient(gradient!, start: startP, end: endP, options: CGGradientDrawingOptions.init(rawValue: 0))
        context.restoreGState()
    }
    
    func convert<T>(length: Int, data: UnsafePointer<UInt8>, _: T.Type) -> [T] {
        let numItems = length/MemoryLayout<T>.stride
        let buffer = data.withMemoryRebound(to: T.self, capacity: numItems) {
            UnsafeBufferPointer(start: $0, count: numItems)
        }
        return Array(buffer)
    }
}
