

import UIKit

public extension UIViewController {
    
    
    /// load controller from storyboard
    ///
    /// - Parameters:
    ///   - storyboard: storyboard
    ///   - identifier: identifier description
    /// - Returns: controller optional
    class func pq_loadSB(storyboard: String,
                      identifier: String?) -> UIViewController? {
        if identifier == nil {
            return UIStoryboard(name: storyboard, bundle: nil).instantiateInitialViewController()
        }
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier!)
    }
    
    
    /// load controller from xib
    ///
    /// - Returns: controller optional
    class func pq_loadXIB() -> UIViewController?{
        if let nibName = NSStringFromClass(self).components(separatedBy: ".").last{
            return UIViewController(nibName: nibName, bundle: nil)
        }
        return nil
    }
    
    
    /// update nav tint color and text color
    ///
    /// - Parameters:
    ///   - tintColor: default is white
    ///   - barTintColor: default is white
    ///   - textColor: default is white
    func pq_navTintColor(_ tintColor: UIColor = .white,
                      barTintColor: UIColor = .white,
                      textColor: UIColor = .white){
        self.navigationController?.navigationBar.tintColor = tintColor
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: textColor]
    }
    
    
    /// remove listen keyboard keyboardWillChangeFrameNotification
    func pq_removeKeyboardLayout() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    /// listen keyboard keyboardWillChangeFrameNotification
    func pq_keyboardLayout(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWiiChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardFrameWiiChange(_ noti : Notification){
        
        let keyboardFrame : CGRect = ((noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        
        //展示
        let frame : CGRect = findFirstResponder(self.view)
        self.pqResponderFrame = .zero
        if frame == .zero || keyboardFrame.minY == UIScreen.main.bounds.height{
            //回收
            UIView.animate(withDuration: 0.25, animations: {[weak self] in
                self?.view.transform = .identity
            })
        }else{
            //得到最大的y轴坐标
            let bottom = frame.maxY + (PQIsiPhoneX ? 98 : 10)
            
            if bottom > keyboardFrame.minY {//表示会被挡住
                UIView.animate(withDuration: 0.25, animations: {[weak self] in
                    self?.view.transform = CGAffineTransform(translationX: 0, y:  keyboardFrame.minY - bottom)
                })
            }
            
        }
    }
    
    private struct pqResponderFrameRT {
        static var frame = "pqResponderFrameRT.frame"
    }
    private var pqResponderFrame: CGRect {
        get {
            let frame = objc_getAssociatedObject(self, &pqResponderFrameRT.frame) as? CGRect
            return frame ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &pqResponderFrameRT.frame, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func findFirstResponder(_ findView: UIView) -> CGRect{
        if pqResponderFrame != .zero {
            return pqResponderFrame
        }
        for view in findView.subviews {
            if view.subviews.count > 0,
                view.subviews.contains(where: { $0 is UITextView || $0 is UITextField }) {
                pqResponderFrame = findFirstResponder(view)
            }
            if view.isFirstResponder {
                if let superV = view.superview {
                    //如果是view的一级子类，就不用转化坐标了
                    if superV.isEqual(self.view) {
                        return view.frame
                    }
                }
                
                pqResponderFrame = view.convert(view.frame, to: self.view)
            }
        }
        return self.pqResponderFrame
    }
}
