//
//  PQProgressView.swift
//  PQProgressView
//
//  Created by 盘国权 on 2018/8/2.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

open class PQProgressView: UIView {
    public enum PQProgressAnimation {
        case flash
        case circle(backgoundColor: UIColor, foregroundColor: UIColor, font: UIFont)
        case wave(waveColor: UIColor)
    }
    
    public enum PQProgressText {
        case white
        case black
        case custom(attributed:  [NSAttributedString.Key: Any])
    }
    
    ///
    public var animationType: PQProgressAnimation = .circle(backgoundColor: .gray, foregroundColor: .white, font: UIFont.systemFont(ofSize: 20))
    /// 进度显示
    public var textType: PQProgressText = .black
    /// 0.0 ~ 1.0
    public var progress: Float = 0.0 {
        didSet{
            animationLayer.update(progress: progress)
            textLabel.text = String(format: "%.0f%%", progress * 100)
            
        }
    }

    /// error text, defualt equal nil
    public var errorText: String? = nil {
        didSet {
            textLabel.numberOfLines = 0
            textLabel.font = UIFont.systemFont(ofSize: 15)
            textLabel.text = errorText
        }
    }
    
    var animationLayer: PQProgressBaseLayer!
    
    public convenience init(frame: CGRect, animationType: PQProgressAnimation, textType: PQProgressText) {
        self.init(frame: frame)
        self.animationType = animationType
        switch textType {
        case .white:
            textLabel.textColor = .white
        case .black:
            textLabel.textColor = .black
        case .custom(let attr):
            textLabel.attributedText = NSAttributedString(string: "0%", attributes: attr)
        }
        
        switch animationType {
        case .flash:
            animationLayer = PQProgressFlashLayer()
        case .circle(let backColor, let foreColor, let font):
            textLabel.font = font
            animationLayer = PQProgressCirclrLayer(backgroundColor: backColor, foregroundColor: foreColor)
        case .wave(let waveColor):
            animationLayer = PQProgressWaveLayer(color: waveColor)
        }
        
        layer.insertSublayer(animationLayer, at: 0)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if animationLayer.frame == .zero {
            animationLayer.frame =  bounds
            animationLayer.drawUI()
        }
        if textLabel.frame == .zero {        
            textLabel.frame = bounds
        }
    }
    
    private lazy var textLabel: UILabel = {
       let label = UILabel(frame: self.bounds)
        self.addSubview(label)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
}
