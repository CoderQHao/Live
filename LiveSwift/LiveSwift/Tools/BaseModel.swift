//
//  BaseModel.swift
//  PlayGolf
//
//  Created by 郝庆 on 2017/1/4.
//  Copyright © 2017年 haoqing. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    override init() {}

    // MARK:- 自定义构造函数
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
