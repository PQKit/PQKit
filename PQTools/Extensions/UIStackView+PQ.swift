

import UIKit

// MARK: UIStackView
public extension UIStackView{
    
    /// fast init UIStackView
    ///
    /// - Parameters:
    ///   - frame: default is nil
    ///   - axis: NSLayoutConstraint.Axis
    ///   - alignment: UIStackView.Alignment
    ///   - distribution: UIStackView.Distribution
    class func pq_init(frame: CGRect = .zero,
                     axis: NSLayoutConstraint.Axis,
                     alignment: UIStackView.Alignment,
                     distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView(frame: frame)
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        return stackView
    }
}
