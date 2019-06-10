
import UIKit


public extension UISlider{
    
    /// fast init slider
    ///
    /// - Parameters:
    ///   - frame: default is zero
    ///   - target: default is nil
    ///   - selector: default is nil
    class func pq_init(frame: CGRect = .zero,
                     target: Any? = nil,
                     selector: Selector? = nil) -> UISlider {
        let slider = UISlider(frame: frame)
        if  let target = target,
            let selector = selector {
            slider.addTarget(target, action: selector, for: .valueChanged)
        }
        return slider
    }
}
