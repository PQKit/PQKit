

import UIKit

public extension UIAlertAction {
    static var isCancelKey = "UIAlertAction.isCancelKey"
    var isCancel: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &UIAlertAction.isCancelKey) as? Bool else {
                objc_setAssociatedObject(self, &UIAlertAction.isCancelKey, false, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return false
            }
            return value
        }
        
        set {
            objc_setAssociatedObject(self, &UIAlertAction.isCancelKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public class PQAlertController: UIAlertController {
    
    public typealias PQActionBlock = ((_ action: UIAlertAction,_ alert: PQAlertController) -> Void)
    public typealias PQTextFieldBlock = ((_ action: UITextField,_ alert: PQAlertController) -> Void)
    @discardableResult public func addButton(_ title: String?, style: UIAlertAction.Style = .default, enable: Bool = true, handler: PQActionBlock?) -> PQAlertController{
        let action = UIAlertAction(title: title, style: style) { (action) in
            if let block = handler{
                block(action,self)
            }
        }
        action.isEnabled = enable
        self.addAction(action)
        return self
    }
    
    @discardableResult public func addButton(_ title: String?, isCancel: Bool, enable: Bool = true, handler: PQActionBlock?) -> PQAlertController{
        let style = isCancel ? UIAlertAction.Style.cancel : UIAlertAction.Style.default
        let action = UIAlertAction(title: title, style: style) { (action) in
            if let block = handler{
                block(action,self)
            }
        }
        action.isCancel = isCancel
        action.isEnabled = enable
        self.addAction(action)
        return self
    }
    
    @discardableResult public func addTextInput(_ placeHolder: String? = nil, textStr: String? = nil, secure: Bool = false, handler: PQTextFieldBlock? = nil) -> PQAlertController{
        if preferredStyle == .actionSheet { return self }
        
        self.addTextField { (text) in
            text.placeholder = placeHolder
            text.text = textStr
            text.isSecureTextEntry = secure
            text.addTarget(self, action: #selector(self.listenTextFieldValueChanged(_:)), for: .editingChanged)
            //保存block
            if let block = handler {
                text.tag = self.nextTag()
                let key = self.getTextFieldKey(text.tag)
                self.textFieldsBlock[key] = block
            }
        }
        
        return self
    }
    
    private func getTextFieldKey(_ tag: Int) -> String{
        return "PQAlertTextField-\(tag)"
    }
    
    private func nextTag() -> Int{
        tag += 1
        return tag
    }
    
    private var textFieldsBlock: [String : PQTextFieldBlock] = [:]
    private var tag: Int = 1
    
}

extension PQAlertController{
    @objc private func listenTextFieldValueChanged(_ textfield: UITextField){
        let key = getTextFieldKey(textfield.tag)
        if let block: PQTextFieldBlock = textFieldsBlock[key] {
            block(textfield,self)
        }
    }
}

public extension PQAlertController {
    convenience init(_ title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert){
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        
        if preferredStyle == .actionSheet, let popPresenter = popoverPresentationController {
            popPresenter.sourceView = UIApplication.shared.keyWindow?.rootViewController?.view
            let bounds = UIScreen.main.bounds
            popPresenter.sourceRect = CGRect(x: bounds.width * 0.5, y: bounds.height, width: 1.0, height: 1.0)
        }
    }
}


public class PQAlertAction: UIAlertAction {
    
    public convenience init(title: String, textColor: UIColor? = nil, handler: ((UIAlertAction) -> Void)?){
        self.init(title: title, style: .default, handler: handler)
        if textColor != nil {
            self.setValue(textColor, forKey: "textColor")
        }
    }
    
    public var textColor: UIColor? {
        didSet{
            var count: UInt32 = 0
            if let ivars = class_copyIvarList(UIAlertAction.self, &count) {
                var i = 0
                while i != count {
                    //取出属性名
                    let ivar = ivars[Int(i)]
                    if let ivarName = ivar_getName(ivar) {
                        let nName = String(cString: ivarName)
                        if nName == "_titleTextColor" {
                            self.setValue(textColor, forKey: "titleTextColor")
                        }
                    }
                    i += 1
                }
            }
            
        }
    }
    
    override public func setValue(_ value: Any?, forKey key: String) {
        if key == "textColor" {
            self.textColor = value as? UIColor
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
}
