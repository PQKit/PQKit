//
//  UIImageView.swift
//  LocalLight
//
//  Created by 盘国权 on 2018/11/26.
//  Copyright © 2018 pgq. All rights reserved.
//

import UIKit

extension PQView where WrapperType == UIImageView  {
    func color(point: CGPoint) -> UIColor? {
        return pq.image?.pq.getPixelColor(pos: point)
    }
}
