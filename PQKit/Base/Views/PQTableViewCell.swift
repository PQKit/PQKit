//
//  BaseTableViewCell.swift
//  SmartMore
//
//  Created by 盘国权 on 2019/4/14.
//  Copyright © 2019 pgq. All rights reserved.
//

import UIKit

open class PQTableViewCell: UITableViewCell {

    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = PQSkip.shared.tbCell.backgroundColor?.spColor
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.backgroundColor = PQSkip.shared.tbCell.backgroundColor?.spColor
        setup()
    }
    
    open override func layoutSubviews() {
        if lineView.frame == .zero {
            contentView.addSubview(lineView)
            let lineHeight = PQSkip.shared.tbCell.lineHeight
            var left: CGFloat = 0
            var right: CGFloat = 0
            if PQSkip.shared.tbCell.lineMargin.count >= 2 {
                left = PQSkip.shared.tbCell.lineMargin[0]
                right = PQSkip.shared.tbCell.lineMargin[1]
            }
            lineView.frame = CGRect(x: left, y: self.contentView.pq.height - lineHeight, width: self.contentView.pq.width - left - right, height: lineHeight)
        }
    }
    
    open var lineColor = PQSkip.shared.tbCell.lineColor?.spColor
    open lazy var lineView: UIView = {
       let view = UIView()
        view.backgroundColor = lineColor
        return view
    }()
    
    open func setup() {}

}
