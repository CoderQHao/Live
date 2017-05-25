//
//  Date+Extension.swift
//  PlayGolf
//
//  Created by 郝庆 on 16/9/30.
//  Copyright © 2016年 haoqing. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ URLString: String?, _ placeHolderName: String?) {
        guard let URLString = URLString else { return }
        
        guard let placeHolderName = placeHolderName else { return }
        
        guard let url = URL(string: URLString) else { return }
        kf.setImage(with: url, placeholder : UIImage(named: placeHolderName))
    }
}
