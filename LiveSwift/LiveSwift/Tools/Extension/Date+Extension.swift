//
//  Date+Extension.swift
//  PlayGolf
//
//  Created by 郝庆 on 16/9/30.
//  Copyright © 2016年 haoqing. All rights reserved.
//

import Foundation

extension Date {
    
    static func getCurrentTime() -> String {
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
