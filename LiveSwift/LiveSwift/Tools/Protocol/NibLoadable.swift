//
//  NibLoadable.swift
//  PlayGolf
//
//  Created by 郝庆 on 2017/5/10.
//  Copyright © 2017年 haoqing. All rights reserved.
//

import UIKit

protocol NibLoadable {
    
}

extension NibLoadable where Self: UIView {
    static func loadFromNib(_ nibname: String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
