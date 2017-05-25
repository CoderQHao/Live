//
//  HQTitleLabel.swift
//  HQPageView
//
//  Created by 郝庆 on 2017/5/8.
//  Copyright © 2017年 Enroute. All rights reserved.
//

import UIKit

class HQTitleLabel: UILabel {
    
    var style: HQTitleStyle! {
        didSet {
            self.font = style.font
            self.textColor = UIColor(red: style.normalColor.0 / 255.0, green: style.normalColor.1 / 255.0, blue: style.normalColor.2 / 255.0, alpha: 1.0)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var scale: CGFloat! {
        didSet {
            let red = style.normalColor.0 / 255.0 + (style.selectedColor.0 / 255.0 - style.normalColor.0 / 255.0) * scale
            let green = style.normalColor.1 / 255.0 + (style.selectedColor.1 / 255.0 - style.normalColor.1 / 255.0) * scale
            let blue = style.normalColor.2 / 255.0 + (style.selectedColor.2 / 255.0 - style.normalColor.2 / 255.0) * scale
            self.textColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            if style.isNeedScale {
                let transformScale = 1 + (style.scaleRange - 1) * scale
                self.transform = CGAffineTransform(scaleX: transformScale, y: transformScale)
            }
        }
    }
}
