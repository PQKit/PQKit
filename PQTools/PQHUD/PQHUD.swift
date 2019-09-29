
import UIKit


public enum PQPushType: String, CaseIterable {
    case set = "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xVzFJMUYxSTE="
    /// wifi
//    case wifi =             "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xVzFJMUYxSTE="
//    /// bluetooth
//    case bluetooth =        "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xQjFsMXUxZTF0MW8xbzF0MWgx"
    /*
    /// 蜂窝移动网络
    case wwan =             "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xTTFPMUIxSTFMMUUxXzFEMUExVDFBMV8xUzFFMVQxVDFJMU4xRzFTMV8xSTFEMQ=="
    /// 热点
    case ap =               "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xSTFOMVQxRTFSMU4xRTFUMV8xVDFFMVQxSDFFMVIxSTFOMUcx"
    /// 运营商
    case carrier =          "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xQzFhMXIxcjFpMWUxcjE="
    /// 通知
    case noti =             "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xTjFPMVQxSTFGMUkxQzFBMVQxSTFPMU4xUzFfMUkxRDE="
    /// 通用
    case general =          "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xRzFlMW4xZTFyMWExbDE="
    /// 关于手机
    case aboutPhone =       "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xRzFlMW4xZTFyMWExbDEmMXAxYTF0MWgxPTFBMWIxbzF1MXQx"
    /// 键盘
    case keybaord =         "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xRzFlMW4xZTFyMWExbDEmMXAxYTF0MWgxPTFLMWUxeTFiMW8xYTFyMWQx"
    /// 辅助功能
    case accessibility =    "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xRzFlMW4xZTFyMWExbDEmMXAxYTF0MWgxPTFBMUMxQzFFMVMxUzFJMUIxSTFMMUkxVDFZMQ=="
    /// 语言地区
    case region =           "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xRzFlMW4xZTFyMWExbDEmMXAxYTF0MWgxPTFJMU4xVDFFMVIxTjFBMVQxSTFPMU4xQTFMMQ=="
    /// 重置手机
    case reset =            "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xUjFlMXMxZTF0MQ=="
    /// 墙纸
    case wallpaper =        "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xVzFhMWwxbDFwMWExcDFlMXIx"
    /// siri
    case siri =             "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xUzFJMVIxSTE="
    /// 隐私
    case privacy =          "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xUDFyMWkxdjFhMWMxeTE="
    /// safari
    case safari =           "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xUzFBMUYxQTFSMUkx"
    /// 音乐
    case music =            "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xTTFVMVMxSTFDMQ=="
    /// 音乐均衡器
    case musicEQ =          "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xTTFVMVMxSTFDMSYxcDFhMXQxaDE9MWMxbzFtMS4xYTFwMXAxbDFlMS4xTTF1MXMxaTFjMToxRTFRMQ=="
    /// 照片与相机
    case photo =            "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xUDFoMW8xdDFvMXMx"
    /// facetime
    case facetime =         "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xRjFBMUMxRTFUMUkxTTFFMQ=="
    case vpn =              "QTFwMXAxLTFQMXIxZTFmMXMxOjFyMW8xbzF0MT0xRzFlMW4xZTFyMWExbDEmMXAxYTF0MWgxPTFOMWUxdDF3MW8xcjFrMS8xVjFQMU4x"
 */
}

public class PQHUD: NSObject {
    //MARK: - public typealias
    public typealias PushCallbackClosure = (Error?) -> Void
    
    
    // MARK: - public property
    
    public static let shared: PQHUD = PQHUD()
    /// default dismiss timeInterval
    public static var dismissTimeInterval: TimeInterval = 0.75
    
    // MARK: - public method
    /// 如果失败会返回false
    @discardableResult
    static func push(_ type: PQPushType) -> Bool {
        guard let data = type.rawValue.data(using: .utf8),
            let base64Data = Data(base64Encoded: data),
            var deStr = String(data: base64Data, encoding: .utf8) else {
                return false
        }
        
        deStr.removeAll(where: { $0 == "1" })
        push(deStr)
        return true
    }
    
    /// 跳转到WIFI设置界面
    //    @discardableResult
    //    public class func jumpToWIFI() -> Bool{
    //        return push(.wifi)
    //    }
    
    //    @discardableResult
    //    public class func jumpToMusic() -> Bool{
    //        return push(.music)
    //    }
    //    @discardableResult
    //    public class func jumpToNoti() -> Bool{
    //        return push(.noti)
    //    }
    
    
    
    static func push(_ string: String, completion: PushCallbackClosure? = nil){
        var error: Error? = nil
        defer { completion?(error) }
        guard let url = URL(string: string) else {
            error = NSError(domain: "Invalid string", code: NSCoderValueNotFoundError, userInfo: ["msg": "Can not convert url: \(string)"])
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    static func jumpToMyAppSet(_ completion: PushCallbackClosure? = nil){
        push(UIApplication.openSettingsURLString, completion: completion)
    }
}



public extension PQHUD  {
    
    /// 返回是否在显示中
    var isVisible: Bool {
        return SVProgressHUD.isVisible()
    }
    
    /// 显示HUD
    @discardableResult
    func show() -> PQHUD {
        SVProgressHUD.show()
        return .shared
    }
    
    /// 显示一段文字，带转圈动画
    ///
    /// - Parameter status: 文字
    @discardableResult
    func show(_ status : String? = nil) -> PQHUD {
        SVProgressHUD.show(withStatus: status)
        return .shared
    }
    
    /// 设置文字,带感叹号
    ///
    /// - Parameter info: 文字
    @discardableResult
    func showInfo(_ info : String? = nil) -> PQHUD {
        SVProgressHUD.showInfo(withStatus: info)
        return .shared
    }
    
    /// 显示一张图片
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - status: 文字
    @discardableResult
    func showImage(_ image :UIImage , status : String? = nil) -> PQHUD {
        SVProgressHUD.show(image, status: status)
        return .shared
    }
    
    /// 显示错误信息，会显示一个x
    ///
    /// - Parameter status: 文字
    @discardableResult
    func showError(_ status: String? = nil) -> PQHUD {
        SVProgressHUD.showError(withStatus: status)
        return .shared
    }
    
    /// 显示进度
    ///
    /// - Parameter progress: 进度
    @discardableResult
    func showProgress(_ progress : Float) -> PQHUD {
        SVProgressHUD.showProgress(progress)
        return .shared
    }
    
    
    /// show GIF image from image named, status default is nil
    ///
    /// - Parameters:
    ///   - imageNamed: named
    ///   - status: default is nil
    /// - Returns: QFHUD
    @discardableResult
    func showGIFImage(named imageNamed: String, status: String? = nil) -> PQHUD {
        if let image = PQGIFImage.image(withGIFNamed: imageNamed) {
            SVProgressHUD.show(image, status: status)
        }else{
            showError("Image is nil, can not show it").dismiss()
        }
        return .shared
    }
    
    /// show GIF image from data, status default is nil
    ///
    /// - Parameters:
    ///   - imageData: data
    ///   - status: default is nil
    /// - Returns: QFHUD
    @discardableResult
    func showGIFImage(data imageData: Data, status: String? = nil) -> PQHUD {
        if let image = PQGIFImage.image(withGIFData: imageData) {
            SVProgressHUD.show(image, status: status)
        }else{
            showError("Image is nil, can not show it").dismiss()
        }
        return .shared
    }
    
    /// show GIF image from url, status default is nil
    ///
    /// - Parameters:
    ///   - urlStr: url string
    ///   - status: default is nil
    /// - Returns: QFHUD
    @discardableResult
    func showGIFImage(url urlStr: String, status: String? = nil) -> PQHUD {
        PQGIFImage.image(withGIFUrl: urlStr, and: { (image) in
            if let image = image {
                SVProgressHUD.show(image, status: status)
            }else{
                self.showError("Image is nil, can not show it").dismiss()
            }
            
        })
        return .shared
    }
    
    /// 显示成功信息，会显示一个✅
    ///
    /// - Parameter status: 文字
    @discardableResult
    func showSuccess(_ status : String? = nil) -> PQHUD {
        SVProgressHUD.showSuccess(withStatus: status)
        return .shared
    }
    
    /// 隐藏
    @discardableResult
    func dismiss(_ timeInterval: TimeInterval = PQHUD.dismissTimeInterval) -> PQHUD {
        SVProgressHUD.dismiss(withDelay: timeInterval)
        return .shared
    }
    /// 隐藏
    @discardableResult
    func dismissNow() -> PQHUD {
        SVProgressHUD.dismiss(withDelay: 0)
        return .shared
    }
    
    /// 隐藏之后如果需要处理，就调用这个方法
    ///
    /// - Parameter completion: 回调
    @discardableResult
    func dismissWithCompletion(completion : @escaping
        SVProgressHUDDismissCompletion) -> PQHUD {
        SVProgressHUD.dismiss(completion: completion)
        return .shared
    }
    
    
    /// 设置消失时间，并且监听回调
    ///
    /// - Parameters:
    ///   - delay: 消失时间
    @discardableResult
    func dismissWithDelay(_ delay : TimeInterval, completion : @escaping SVProgressHUDDismissCompletion) -> PQHUD {
        SVProgressHUD.dismiss(withDelay: delay, completion: completion)
        return .shared
    }
}

