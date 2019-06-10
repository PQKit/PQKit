
import UIKit

// MARK: UICollectionView
public extension UICollectionView{
    
    /// fast init collectionView
    ///
    /// - Parameters:
    ///   - frame: .zero
    ///   - size: size
    ///   - derection: .veritical
    ///   - headerReferenceSize: zero
    ///   - minLineSpacing: 0
    ///   - minInterItemSpacing: 0
    ///   - delegate: nil
    ///   - dataSource: nil
    class func pq_init(frame: CGRect = .zero,
                     item size: CGSize,
                     derection: UICollectionView.ScrollDirection = .vertical,
                     headerReferenceSize: CGSize = .zero,
                     minLineSpacing: CGFloat = 0,
                     minInterItemSpacing: CGFloat = 0,
                     delegate: UICollectionViewDelegate? = nil,
                     dataSource: UICollectionViewDataSource? = nil) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = headerReferenceSize
        layout.scrollDirection = derection
        layout.minimumLineSpacing = minLineSpacing
        layout.minimumInteritemSpacing = minInterItemSpacing
        layout.itemSize = size
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        
        return collectionView
    }
}
