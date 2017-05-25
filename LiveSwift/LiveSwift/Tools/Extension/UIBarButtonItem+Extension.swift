//
//  UIBarButtonItem+Extension.swift
//  PlayGolf
//
//  Created by 郝庆 on 16/12/23.
//  Copyright © 2016年 haoqing. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName : String) {
        self.init()
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
//        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.setImage(UIImage(named: imageName), for: .highlighted)
        btn.sizeToFit()

        self.customView = btn
    }
}
