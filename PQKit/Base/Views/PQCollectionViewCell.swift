//
//  BaseCollectionViewCell.swift
//  SmartMore
//
//  Created by 盘国权 on 2019/4/12.
//  Copyright © 2019 pgq. All rights reserved.
//

import UIKit

open class PQCollectionViewCell: UICollectionViewCell {
    // MARK: system method
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = PQSkip.shared.cvCell.backgroundColor?.spColor
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.backgroundColor = PQSkip.shared.cvCell.backgroundColor?.spColor
        setup()
    }
    
    //MARK: - public method
    open func setup() { }
}
