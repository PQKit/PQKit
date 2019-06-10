

import UIKit

public extension UITableView{
    class func pq_init(frame: CGRect = .zero,
                     delegate: UITableViewDelegate? = nil,
                     dataSource: UITableViewDataSource? = nil,
                     rowHeight: CGFloat = 44) -> UITableView{
        let tbView = UITableView(frame: frame)
        tbView.delegate = delegate
        tbView.dataSource = dataSource
        tbView.rowHeight = rowHeight
        return tbView
    }
}
