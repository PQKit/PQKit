

import UIKit

public struct PQImage<T>: PQType {
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}

extension UIImage {
    public var pq: PQImage<UIImage> {
        return PQImage(pq: self)
    }
}

public struct DrawBackItem {
    /// default .white
    public var backImageColor: UIColor = UIColor.white
    /// default 2
    public var backLineWidth: CGFloat = 2
    /// 占整个高度的多少
    public var backLineHeightScale: CGFloat = 0.8
    /// default nil
    public var text: String? = nil
    /// default 15
    public var fontSize: CGFloat = 15
    /// default .white
    public var textColor: UIColor = UIColor.white
    /// default CGSize(width: 60, height: 30)
    public var size: CGSize = CGSize(width: 60, height: 30)
    
    public init() {}
    public init(backImageColor: UIColor, lineWidth: CGFloat = 2) {
        self.backImageColor = backImageColor
        self.backLineWidth = lineWidth
    }
    
    public init(text: String, textColor: UIColor = UIColor.white) {
        self.text = text
        self.textColor = textColor
    }
    
    public init(backImageColor: UIColor, text: String, textColor: UIColor) {
        self.backImageColor = backImageColor
        self.text = text
        self.textColor = textColor
    
    }
    
}

public extension PQImage where WrapperType == UIImage {
    
    
    /// 获取图片中点的颜色
    ///
    /// - Parameters:
    ///   - point: 点
    ///   - viewSize: 视图大小 bounds
    /// - Returns: 颜色 可能为空
    func color(point: CGPoint, viewSize: CGSize) -> UIColor?{
        // 1计算点
        var newPoint = point;
        if viewSize.width != pq.size.width {
            let scaleW = point.x / viewSize.width
            newPoint.x = pq.size.width * scaleW
        }
        if viewSize.height != pq.size.height {
            let scaleH = point.y / viewSize.height
            newPoint.y = pq.size.height * scaleH
        }
        
        // 2判断在不在范围内
        if CGRect(x: 0, y: 0, width: pq.size.width, height: pq.size.height).contains(newPoint) == false {
            return nil
        }
        
        guard let cgImage = pq.cgImage else { return nil }
        
        
        //3、创建颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerpixel = 4
        let bytesPerRow = bytesPerpixel * 1
        let bitsPereComponent = 8
        
        var pixelData = [0,0,0,0]
        
        
        let ctx = CGContext(data: &pixelData,
                            width: 1,
                            height: 1,
                            bitsPerComponent: bitsPereComponent,
                            bytesPerRow: bytesPerRow,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.order32Big.rawValue)
        
        
        
        
        ctx?.setBlendMode(.copy)
        ctx?.translateBy(x: -newPoint.x, y: newPoint.y - pq.size.height)
        let rect = CGRect(x: 0, y: 0, width: pq.size.width, height: pq.size.height)
        ctx?.draw(cgImage, in: rect)
        
        
        let red = CGFloat(pixelData[0]) / 255.0
        let green = CGFloat(pixelData[1]) / 255.0
        let blue = CGFloat(pixelData[2]) / 255.0
        let alpha = CGFloat(pixelData[3]) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
    }
    
    /**
     获取图片中的像素颜色值
     
     - parameter pos: 图片中的位置
     
     - returns: 颜色值
     */
    func getPixelColor(pos:CGPoint) -> UIColor?{
        guard let cfData = pq.cgImage?.dataProvider?.data else { return nil }
        
        //        let pixelData =  CGDataProvider(data: cfData)
        
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(cfData)
        let pixelInfo: Int = ((Int(pq.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    
    /// scale size
    ///
    /// - Parameter size: size
    /// - Returns: image?
    func scale(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 50, height: 50), false, UIScreen.main.scale)
        pq.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 50)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// scale value
    ///
    /// - Parameter value: value
    /// - Returns: image?
    func scale(value: CGFloat) -> UIImage? {
        var size = pq.size
        size.width = size.width * value
        size.height = size.height * value
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        pq.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

public extension UIImage {
    /// 画纯色图片
    class func pq_drawRect(_ size: CGSize, color: UIColor, radius: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.setFill()
        UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    /// 会椭圆 如果传入的是正方形就是圆形
    class func pq_drawCircle(_ size: CGSize, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.setFill()
        UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height)).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func pq_drawView(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            view.layer.render(in: ctx)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    /// 画一个带阴影的图片
    ///
    /// - Parameters:
    ///   - radius: 图片圆角
    ///   - size: 图片大小
    ///   - color: 图片颜色
    ///   - shadowColor: 阴影颜色
    ///   - shadowOffset: 阴影偏移位置
    ///   - blur: default 5
    /// - Returns: 图片
    class func pq_drawShadowImage(_ radius: CGFloat, size: CGSize, color: UIColor = .white, shadowColor: UIColor = UIColor.black.withAlphaComponent(0.3), shadowOffset: CGSize = CGSize.zero, blur: CGFloat = 5, drawMode: CGPathDrawingMode = .eoFill) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        color.setFill()
        let drawSize = CGSize(width: size.width - radius, height: size.height - radius)
        let point = CGPoint(x: (size.width - drawSize.width) * 0.5, y: (size.height - drawSize.height) * 0.5)
        let path1 = UIBezierPath(roundedRect: CGRect(origin: point , size: drawSize), cornerRadius: radius)
        ctx?.addPath(path1.cgPath)
        ctx?.setShadow(offset: shadowOffset, blur: blur, color: shadowColor.cgColor)
        ctx?.drawPath(using: drawMode)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 绘制返回按钮
    class func pq_drawBackImage(_ item: DrawBackItem) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(item.size, false, UIScreen.main.scale)
        // 0 填充颜色
        item.backImageColor.setStroke()
        // 1 画返回箭头
        let height = item.size.height;
        let backImageWidth = item.size.width * 0.4
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineWidth = item.backLineWidth
        path.move(to: CGPoint(x: backImageWidth * 0.75, y: height * (1 - item.backLineHeightScale) * 0.5))
        path.addLine(to: CGPoint(x: backImageWidth * 0.25, y: height * 0.5))
        path.addLine(to: CGPoint(x: backImageWidth * 0.75, y: height * (item.backLineHeightScale + (1 - item.backLineHeightScale) * 0.5)))
        path.stroke()
        
        // 2 判断有没有文字
        if let text = item.text as NSString? {
            let height = text.boundingRect(with: CGSize(width: item.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesDeviceMetrics, attributes: nil, context: nil).height + 8
            
            let rect = CGRect(x: backImageWidth, y: (item.size.height - height) * 0.5, width: item.size.width * 0.6, height: height)
            var dict: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: item.fontSize)]
            dict[NSAttributedString.Key.foregroundColor] = item.textColor
            
            text.draw(in: rect, withAttributes: dict)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 画一张图片，以progress为准，例如白色到黑色 Progress = 0.5 那么拿到的颜色就是灰色
    ///
    /// - Parameters:
    ///   - from: from color
    ///   - to: to color
    ///   - progress: progress, use progress callback color
    ///   - size: size
    /// - Returns: image
    class func pq_drawColorImage(from: UIColor, to: UIColor, progress: Float, size: CGSize = CGSize(width: 40, height: 40)) -> (color: UIColor, image: UIImage) {
        let fromRGBAInfo = from.pq.rgba()
        let toRGBAInfo = to.pq.rgba()
        
        let red: CGFloat = fromRGBAInfo.red + (toRGBAInfo.red - fromRGBAInfo.red) * CGFloat(progress)
        let green: CGFloat = fromRGBAInfo.green + (toRGBAInfo.green - fromRGBAInfo.green) * CGFloat(progress)
        let blue: CGFloat = fromRGBAInfo.blue + (toRGBAInfo.blue - fromRGBAInfo.blue) * CGFloat(progress)
        let alpha: CGFloat = fromRGBAInfo.alpha + (toRGBAInfo.alpha - fromRGBAInfo.alpha) * CGFloat(progress)
        print(red,green,blue,alpha)
        UIGraphicsBeginImageContext(size)
        let color = UIColor(red: red , green: green, blue: blue, alpha: alpha)
        color.setFill()
        UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: 5).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return (color: color, image: image ?? UIImage())
    }
}



